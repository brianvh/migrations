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
    return true if is_support?
    device.user_id == self.id
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
end
