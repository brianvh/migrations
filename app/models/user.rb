class User < ActiveRecord::Base
  include DNDUser
  
  has_many :profiles
  has_many :devices

  before_validation :valid_in_dnd?, :on => :create

  validates_uniqueness_of :uid, :on => :create, :message => "must be unique"

  def is_support?
    false
  end

  def is_admin?
    false
  end

  def is_webmaster?
    false
  end

  def last_first
    "#{lastname}, #{firstname}"
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
