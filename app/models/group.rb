class Group < ActiveRecord::Base
  
  default_scope order(:name)
  
  has_many :memberships
  has_many :users, :through => :memberships

  include Groups::Contacts
  include Groups::Members
  include Groups::Deptclass
  include Groups::Consultants
  include Groups::Calendars

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false, :message => "must be unique"
  validates_presence_of :week_of
  validate :valid_deplclasses?, :on => :create

  attr_writer :action

  attr_accessor :accounts
  attr_accessor :migration_id
  attr_accessor :skip_notifications
  
  attr_accessor :migration_types_choices
  
  serialize :migration_types
  
  def migration_types_choices=(choices)
    unless choices.nil?
      choices.delete("") # remove blank hidden field
      unless choices.empty?
        return self.migration_types = choices
      end
    end
    self.migration_types = []
  end

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
    memberships.where(
     "memberships.type = 'Member' or memberships.type='Contact'").includes(
     :user).order(
     "users.deptclass, users.name").each do |member|
      users_to_migrate << member.user if (member.user.needs_migration? && !users_to_migrate.include?(member.user))
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

  def delete_group_and_memberships
    members.delete_all
    calendars.delete_all
    contacts.delete_all
    consultants.delete_all
    self.delete
  end

  def week_of_date
    return "" if week_of.blank?
    begin
      the_date = Chronic.parse(week_of)
      the_date.strftime('%B %d, %Y').sub(/ 0([\d])/,' \1')
    rescue
      week_of
    end
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
