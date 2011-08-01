class User < ActiveRecord::Base
  include DNDUser

  before_validation :valid_in_dnd?, :on => :create

  validates_uniqueness_of :uid, :on => :create, :message => "must be unique"

  def is_admin?
    false
  end

  def is_webmaster?
    false
  end

  def self.authenticate(auth_hash)
    return nil unless auth_hash['provider'] == 'cas'
    realm = auth_hash['uid'].split(/@/)[1].downcase
    return nil unless realm == 'dartmouth.edu'
    User.find_by_uid(auth_hash['extra']['uid'])
  end
end
