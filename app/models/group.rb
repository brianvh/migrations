class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships

  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :name, :on => :create, :message => "must be unique"
  validate :valid_deplclasses?, :on => :create
  after_save :add_deptclass_users, :remove_deptclass_users, :remove_member

  attr_accessor :member_id
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

  def add_deptclass
    deptclass
  end

  def add_deptclass=(depts)
    self.deptclass = depts
  end

  def remove_deptclass
    deptclass
  end

  def remove_deptclass=(depts)
    self.deptclass = depts
  end

  def users_added
    @users_added || 0
  end

  def users_removed
    @users_removed || 0
  end

  def contacts_display
    ''
  end

  def consultants_display
    ''
  end

  def action
    @action_sym ||= @action.to_sym
  end

  private

  def valid_deplclasses?
    return if deptclass.blank?
    return unless deptclass_users.empty?
    errors.add(:deptclass, 'The deptclass value you entered matches no users.')
    false
  end

  def add_deptclass_users
    return unless adding_deptclass?
    deptclass_users.each { |user| add_user(user.id) }
    @users_added = deptclass_users.size
  end

  def remove_deptclass_users
    return unless removing_deptclass?
    memberships_to_remove.each { |memship| memship.destroy }
    @users_removed = memberships_to_remove.size
  end

  def remove_member
    return unless removing_member?
    member_to_remove.destroy unless member_to_remove.nil?
  end

  def adding_deptclass?
    add_deptclass.blank? ? false : [:create, :add_deptclass].include?(action)
  end

  def removing_deptclass?
    remove_deptclass.blank? ? false : action == :remove_deptclass
  end

  def removing_member?
    member_id.nil? ? false : action = :remove_member
  end

  def deptclass_users
    @deptclass_users ||= User.where(:deptclass => deptclass)
  end

  def memberships_to_remove
    @memberships_to_remove ||= memberships.includes(:user).
      where('users.deptclass' => remove_deptclass)
  end

  def member_to_remove
    @member_to_remove ||= memberships.where(:user_id => member_id).first
  end

  def add_user(user_id)
    memberships.create(:user_id => user_id)
  end
end
