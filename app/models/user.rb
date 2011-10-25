class User < ActiveRecord::Base
  include DNDUser
  include LDAPUser
  
  default_scope :order => [:deptclass, :name]
  
  has_many :profiles
  has_many :devices
  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :primary_resource_ownerships, :class_name => "Resource", :foreign_key => "primary_owner_id"
  has_many :secondary_resource_ownerships, :class_name => "Resource", :foreign_key => "secondary_owner_id"
  has_many :migration_events
  has_many :migrations, :through => :migration_events
  
  before_validation :valid_in_dnd?, :on => :create
  validates_uniqueness_of :uid, :on => :create, :message => "must be unique"

  after_create :activate

  attr_writer :action

  delegate :netid, :affiliation, :blitzserv, :emailsuffix, :phone, :to => :profile

  state_machine :initial => :pending do

    event :activate do
      transition any => :active
    end

    event :deactivate do
      transition any => :expired
    end
    after_transition :on => :deactivate, :do => :drop_from_migration

    event :skip_migration do
      transition [:active, :pending] => :do_not_migrate
    end

    event :reset do
      transition any => :pending
    end

  end

  def is_support?
    false
  end

  def is_admin?
    false
  end

  def is_webmaster?
    false
  end
  
  def is_tech?
    false
  end

  def can_access_device?(device)
    is_support? ? true : device.user_id == self.id
  end

  def can_access_group?(group)
    is_support? ? true : is_contact?(group)
  end

  def is_contact?(group)
    group.contacts.include?(self) ? true : false
  end

  def is_consultant?(group)
    group.consultants.include?(self) ? true : false
  end

  def needs_resync?
    return false if updated_at.nil?
    Time.now.to_date > updated_at.to_date
  end

  def profile_fetched?
    @profile_fetched == true
  end

  def profile
    fetch_profile unless profile_fetched?
    @profile
  end

  def last_first
    @last_first ||= firstname.present? ? "#{lastname}, #{firstname}" : lastname
  end

  def group_name
    groups.first.nil? ? '' : groups.first.name
  end

  def profile_state
    return 'Pending' if migration_profile.nil?
    return "Reviewed" if migration_profile.reviewed?
    return 'Incomplete' if migration_profile.missing_vital_attributes?
    'Submitted'
  end

  def migration_profile
    @migration_profile ||= profiles.first
  end

  def migration_event_state_for_display
    return migration.migration.date if migration.pending?
    migration_events.first.human_state_name
  end
  
  def has_migration?
    return true if migration_events.first
    false
  end
  
  def migration
    return migration_events.first if has_migration?
  end
  
  def migration_complete?
    return true if ( !mailboxtype.nil? && mailboxtype.downcase == 'cloud' )
    false
  end

  def migration_state
    return "EXPIRED" if expired?
    return 'DO NOT MIGRATE' if do_not_migrate?
    return 'Complete' if migration_complete?
    return migration_event_state_for_display if has_migration?
    'Unscheduled'
  end
  
  def drop_from_migration
    migration_events.first.delete unless migration_events.empty?
  end
  
  def needs_migration?
    return false if migration_complete?
    return false unless active?
    return false if do_not_migrate?
    return false if has_migration?
    true
  end
  
  def is_group_account?
    return true if affiliation =~ /DEPT|GROUP|ORG/
    false
  end
  
  def should_not_receive_invitation?
    return true if active?
    return true if migration_complete?
    return true if do_not_migrate?
    is_group_account?
  end

  def resources_to_migrate
    resources = []
    primary_resource_ownerships.each do |calendar|
      resources << calendar if calendar.needs_migration?
    end
    resources
  end
  
  def owns_resource?(resource)
    !primary_resource_ownerships.where(:id => resource.id).empty?
  end
  
  def display_mailboxtype
    mbt = mailboxtype
    return "Blitz" if (mbt.blank? || mbt == 'blitz')
    mbt.titleize
  end

  def emailsuffix
    parts = email.split('@')
    case
    when m = /^'([0-9][0-9])/.match(deptclass.strip)
      suffix = "." + (Regexp.new("#{m[1]}$").match(parts[0]) ? "" : m[1])
    when suffix_map.key?(deptclass.strip)
      suffix = "." + suffix_map[deptclass.strip]
    else
      suffix = ""
    end
  end

  def newemailaddress
    return email if mailboxtype =~ /cloud/i
    parts = email.split('@')
    "#{parts[0]}#{emailsuffix}@#{parts[1]}"
  end

  def invitation_sent_for_group?(group)
    memberships.where("group_id = #{group.id} AND (type = 'Member' OR type = 'Contact')").first.invitation_sent?
  end
  
  def block_from_migration
    skip_migration
  end
  
  def unblock_from_migration
    reset
    activate
  end

  def cancel_resource_migrations
    primary_resource_ownerships.each do |ownership|
      ownership.cancel_migration
    end
  end

  def migdate
    migration_events.first.migration.date.strftime('%B %d, %Y').sub(/ 0([\d])/,' \1')
  end

  def day_after_migdate
    (migration_events.first.migration.date + 1.day).strftime('%B %d, %Y').sub(/ 0([\d])/,' \1')
  end

  def migday
    migration_events.first.migration.date.strftime('%A')
  end

  def self.authenticate(authenticator)
    User.find_by_uid(authenticator.uid)
  end

  def self.lookup_by_name(name)
    lookup = User.new(:name => name)
    lookup.profile.nil? ? nil : User.find_by_uid(lookup.profile.uid)
  end
  
  def self.deptclass_unique_array
    select("DISTINCT(deptclass)").order(:deptclass).map { |u| u.deptclass }
  end

  def self.find_for_deptclass(dept, ids_to_exclude=[])
    User.where(:deptclass => dept).select { |u| ! ids_to_exclude.include?(u.id) }
  end

  private

  def fetch_profile
    dnd_prof = nil
    Net::DartmouthDND.start(profile_fields) do |dnd|
      dnd_prof = dnd.find(uid || name, :one)
    end
    @profile = dnd_prof
    @profile_fetched = true
    resync_profile
  end

  def resync_profile
    return unless needs_resync?
    profile_to_attributes
    cache_expires
    self.touch
  end

  def suffix_map
    {
      "DM" => "DM",
      "FOR UN" => "",
      "GR" => "GR",
      "GREC" => "GR",
      "GRGS" => "GR",
      "GRHC" => "GR",
      "GRLS" => "GR",
      "HS" => "HS",
      "MT" => "MT",
      "S1" => "S1",
      "SC" => "SC",
      "SD" => "SD",
      "SX" => "SX",
      "TH" => "TH",
      "TU" => "TU",
      "TU08" => "TU08",
      "TU09" => "TU09",
      "TU10" => "TU10",
      "TU11" => "TU11",
      "TU12" => "TU12",
      "UG" => "UG"
    }
  end

end
