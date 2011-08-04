class User < ActiveRecord::Base
  include DNDUser
  
  has_many :profiles
  has_many :devices

  before_validation :valid_in_dnd?, :on => :create

  validates_uniqueness_of :uid, :on => :create, :message => "must be unique"

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

  def self.authenticate(auth_hash)
    return nil unless auth_hash['provider'] == 'cas'
    realm = auth_hash['uid'].split(/@/)[1].downcase
    return nil unless realm == 'dartmouth.edu'
    User.find_by_uid(auth_hash['extra']['uid'])
  end
end
