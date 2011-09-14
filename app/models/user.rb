class User < ActiveRecord::Base
  include DNDUser
  include LDAPUser
  
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

  delegate  :netid, :affiliation, :blitzserv, :email, :emailsuffix,
            :phone, :assignednetid, :to => :profile

  state_machine :initial => :pending do

    event :activate do
      transition any => :active
    end

    event :deactivate do
      transition any => :expired
    end

    event :skip_migration do
      transition :active => :do_not_migrate
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
    migration_events.first.state.titleize
  end
  
  def has_migration_event?
    migration_events.first
  end

  def migration_state
    if has_migration_event?
      return migration_event_state_for_display
    else
      return 'Complete' if mailboxtype == 'cloud'  # =~ /cloud|exchange/i
      'Pending'
    end
  end
  
  def needs_migration?
    return false if mailboxtype == 'cloud'
    return false if migration_events.first
    true
  end

  def invitation_sent_for_group?(group)
    memberships.where(:group_id => group.id, :type => 'Member').first.invitation_sent?
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
end
