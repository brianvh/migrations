class Group < ActiveRecord::Base
  
  default_scope order(:name)
  
  has_many :memberships
  has_many :users, :through => :memberships

  include Groups::Contacts
  include Groups::Members
  include Groups::Deptclass
  include Groups::Consultants
  include Groups::Calendars

  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :name, :on => :create, :message => "must be unique"
  validate :valid_deplclasses?, :on => :create

  attr_writer :action

  attr_accessor :accounts
  attr_accessor :migration_id
  attr_accessor :skip_notifications
  
  def skip_notifications=(params)
    @skip_notifications = params
  end
  
  def skip_notifications
    @skip_notifications ||= false
  end
  
  def accounts=(params)
    @accounts = params
  end
  
  def accounts
    @accounts ||= []
  end
  
  def migration_id=(params)
    @migration_id = params
  end
  
  def migration_id
    @migration_id ||= nil
  end

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
  
  def member_count
    contacts.count + members.count
  end
  
  def invitations_sent
    @invitations_sent || 0
  end

  def users_added
    @users_added ||= 0
  end
  
  def resources_added
    @resources_added ||= 0
  end

  def send_invitations
    bcc = []
    sent_to_ids = []
    recips = contacts.map { |c| c.email } # contacts always get email addressed to them
    memberships.find_all_by_type('Member').each do |m| # other group members addressed in bulk as bcc
      unless m.invitation_sent || !m.user.needs_migration?
        bcc << m.user.email
        sent_to_ids << m.id
      end
    end
    
    unless recips.empty? && bcc.empty?
      NotificationMailer.invite_group(self, recips, bcc).deliver
      Membership.update_all({:invitation_sent => true},
                             "group_id = #{self.id} AND type = 'Member' AND id IN (#{sent_to_ids.join(',')})")
    end

    @invitations_sent = recips.count + bcc.count

  end

  def find_for_migrate
    users_to_migrate = []
    resources_to_migrate = []
    (members + contacts).each do |member|
      users_to_migrate << member if member.needs_migration?
      resources_to_migrate << member.resources_to_migrate
    end
    users_to_migrate + resources_to_migrate.flatten
  end
  
  def find_users_for_migration
    users_to_migrate = []
    (members + contacts).each do |member|
      users_to_migrate << member if member.needs_migration?
    end
    users_to_migrate
  end
  
  def find_unowned_resources_for_migration
    calendars.where(:primary_owner_id => nil)
  end
  
  def schedule_migrations
    migration = Migration.find(migration_id)
    migration.add_users_and_resources(accounts, skip_notifications)
    @users_added = migration.users_added
    @resources_added = migration.resources_added
  end

  private

  def valid_deplclasses?
    return if deptclass.blank?
    return unless deptclass_users.empty?
    errors.add(:deptclass, 'The deptclass value you entered matches no users.')
    false
  end

  def deptclass_users
    @deptclass_users ||= User.find_for_deptclass(deptclass, member_ids)
  end

end
