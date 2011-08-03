class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships

  attr_reader :users_added

  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :name, :on => :create, :message => "must be unique"
  validate :valid_deplclasses?, :on => :create
  after_create :add_deptclass_users

  def deptclass_display
    deptclass.join(', ')
  end

  def deptclass
    @deptclass ||= []
  end

  def deptclass=(depts)
    @deptclass = depts.split(/, */)
  end

  private

  def valid_deplclasses?
    return if deptclass.blank?
    return unless deptclass_users.empty?
    errors.add(:deptclass, 'The deptclass value you entered matches no users.')
    false
  end

  def add_deptclass_users
    return if deptclass.blank?
    deptclass_users.each { |user| add_user(user.id) }
    @users_added = deptclass_users.size
  end

  def deptclass_users
    @deptclass_users ||= User.where(:deptclass => deptclass)
  end

  def add_user(user_id)
    memberships.create(:user_id => user_id)
  end
end
