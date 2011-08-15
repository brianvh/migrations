class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships

  has_many :member_users, :class_name => "Member", :foreign_key => "group_id"
  has_many :members, :through => :member_users, :source => :user

  has_many :contact_users, :class_name => "Contact", :foreign_key => "group_id"
  has_many :contacts, :through => :contact_users, :source => :user

  has_many :consultant_users, :class_name => "Consultant", :foreign_key => "group_id"
  has_many :consultants, :through => :consultant_users, :source => :user

  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :name, :on => :create, :message => "must be unique"
  validate :valid_deplclasses?, :on => :create
  after_save  :add_deptclass_users, :remove_deptclass_users, :remove_member,
              :add_contact, :remove_contact

  attr_accessor :member_id, :contact_id
  attr_writer :action
  attr_reader :contact_name

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

  def members_added
    @members_added || 0
  end

  def members_removed
    @members_removed || 0
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

  def members_for_contact_list
    contact_ids = contacts.map(&:id)
    members.select { |m| !contact_ids.include?(m.id) }.map { |m| [m.last_first, m.id] }
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
    deptclass_users.each { |member| add_member(member.id) }
    @members_added = deptclass_users.size
  end

  def remove_deptclass_users
    return unless removing_deptclass?
    member_users_to_remove.each { |memship| memship.destroy }
    @members_removed = member_users_to_remove.size
  end

  def remove_member
    return unless removing_member?
    member_user_to_remove.destroy unless member_user_to_remove.nil?
  end

  def add_contact
    return unless adding_contact?
    promote_member
  end

  def remove_contact
    return unless removing_contact?
    demote_contact
  end

  def adding_deptclass?
    add_deptclass.blank? ? false : [:create, :add_deptclass].include?(action)
  end

  def removing_deptclass?
    remove_deptclass.blank? ? false : action == :remove_deptclass
  end

  def removing_member?
    member_id.nil? ? false : action == :remove_member
  end

  def adding_contact?
    contact_id.nil? ? false : action == :choose_contact
  end

  def removing_contact?
    contact_id.nil? ? false : action == :clear_contact
  end

  def deptclass_users
    @deptclass_users ||= User.where(:deptclass => deptclass)
  end

  def member_users_to_remove
    @member_users_to_remove ||= memberships.includes(:user).
      where('users.deptclass' => remove_deptclass)
  end

  def member_user_to_remove
    @member_user_to_remove ||= member_users.where(:user_id => member_id).first
  end

  def add_member(mem_id)
    member_users.create(:user_id => mem_id)
  end

  def promote_member
    member = member_users.where(:user_id => contact_id).first
    member.update_attribute :type, 'Contact'
    @contact_name = member.user.last_first
  end

  def demote_contact
    contact = contact_users.where(:user_id => contact_id).first
    contact.update_attribute :type, 'Member'
    @contact_name = contact.user.last_first
  end
end
