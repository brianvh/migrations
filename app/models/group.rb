class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships

  include Groups::Contacts
  include Groups::Members
  include Groups::Deptclass
  include Groups::Consultants

  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :name, :on => :create, :message => "must be unique"
  validate :valid_deplclasses?, :on => :create

  attr_writer :action

  def deptclass_display
    deptclass.join(', ')
  end

  def deptclass
    @deptclass ||= []
  end

  def deptclass=(depts)
    @deptclass = depts.split(/, */)
  end

  def action
    @action_sym ||= @action.to_sym
  end
  
  def member_deptclasses
    users.all.map { |u| u.deptclass }.uniq.sort
  end

  private

  def valid_deplclasses?
    return if deptclass.blank?
    return unless deptclass_users.empty?
    errors.add(:deptclass, 'The deptclass value you entered matches no users.')
    false
  end

  def deptclass_users
    @deptclass_users ||= User.where(:deptclass => deptclass)
  end

end
