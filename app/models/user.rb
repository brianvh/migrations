class User < ActiveRecord::Base
  include DNDUser
  
  has_many :profiles
  has_many :devices
  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :primary_resource_ownerships, :class_name => "Resource", :foreign_key => "primary_owner_id"
  has_many :secondary_resource_ownerships, :class_name => "Resource", :foreign_key => "secondary_owner_id"

  before_validation :valid_in_dnd?, :on => :create
  validates_uniqueness_of :uid, :on => :create, :message => "must be unique"

  delegate  :netid, :affiliation, :blitzserv, :email, :emailsuffix,
            :mailboxtype, :phone, :to => :profile

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

  def profile_summary
    'TODO'
  end

  def migration_date
    'TODO'
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

  private

  def fetch_profile
    dnd_prof = nil
    Net::DartmouthDND.start(profile_fields) do |dnd|
      dnd_prof = dnd.find(uid || name, :one)
    end
    Rails.logger.info("\nProfile Fetched!\n")
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
