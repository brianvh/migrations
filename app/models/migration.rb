class Migration < ActiveRecord::Base
  
  default_scope order("date DESC")

  has_many :migration_events
  
  has_many :user_migration_events
  has_many :users, :through => :user_migration_events
  
  has_many :devices, :through => :users, :source => :devices
  
  has_many :resource_migration_events
  has_many :resources, :through => :resource_migration_events
  
  validates :date,
            :uniqueness => { :message => "there is already a migration established for that day" },
            :on => :create, :unless => Proc.new { |m| m.action }
            
  validates :max_accounts,
            :numericality => { :greater_than_or_equal_to => 0, :only_integer => true },
            :unless => Proc.new { |m| m.action }
  
  validate :valid_date, :unless => Proc.new { |m| m.action }
  
  attr_accessor :user_id
  attr_accessor :resource_id
  attr_accessor :migration_id
  attr_accessor :action
  attr_accessor :users_added
  attr_accessor :resources_added
  attr_accessor :skip_notifications
  
  attr_accessor :migration_types_choices

  attr_accessor :cancel_email_message, :cancel_email_subject, :send_cancel_notification
  attr_accessor :reschedule_email_message, :reschedule_email_subject, :send_reschedule_notification
  
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

  def display_migration_types
    return "Any" if (migration_types.nil? || migration_types.empty? || migration_types.size == 3)
    migration_types.join(", ")
  end
  
  def skip_notifications=(params)
    @skip_notifications = params
  end
  
  def skip_notifications
    @skip_notifications ||= false
  end
  
  def delete_events_and_self
    self.user_migration_events.destroy_all
    self.resource_migration_events.destroy_all
    self.delete
  end
  
  def users_sorted
    users.order("users.lastname, users.firstname")
  end
  
  def resources_sorted
    resources.order("name")
  end
  
  def user_id=(params)
    @user_id = params
  end
  
  def user_id
    @user_id ||= nil
  end
  
  def resource_id=(params)
    @resource_id = params
  end
  
  def resource_id
    @resource_id ||= nil
  end
  
  def action=(params)
    @action = params
  end
  
  def action
    @action ||= nil
  end
  
  def migration_id
    @migration_id ||= nil
  end
  
  def migration_id=(params)
    @migration_id = params
  end
  
  def users_added
    @users_added ||= 0
  end
  
  def users_added=(params)
    @users_added = params
  end
  
  def resources_added
    @resources_added ||= 0
  end
  
  def resources_added=(params)
    @resources_added = params
  end
  
  def total_accounts
    users.size + resources.size
  end
  
  def add_users_and_resources(new_users, skip_notifications)
    new_users.each do |new_user|
      user = User.find(new_user)
      add_user(user, skip_notifications)
      add_user_resources(user)
    end
  end
  
  def add_user_resources(user)
    new_resources = user.resources_to_migrate ||= []
    unless new_resources.empty?
      resources << new_resources
      resources.flatten
      self.resources_added += new_resources.size
    end
  end
  
  def add_user(new_user, skip_notifications)
    if new_user.needs_migration?
      users << new_user
      new_user.migration.skip_notifications if skip_notifications == "1"
      self.users_added += 1
    end
  end
  
  def week_of
    date.beginning_of_week
  end
  
  def cancel_user_migration(params)
    event = migration_events.where(:user_id => params[:user_id]).first
    if event
      event.user.cancel_resource_migrations
      UserMigrationEvent.delete(event)
      NotificationMailer.notify_on_cancel(event.user, params[:cancel_email_subject], params[:cancel_email_message]).deliver if params[:send_cancel_notification] == "1"
      NotificationMailer.notify_on_reschedule(event.user, params[:reschedule_email_subject], params[:reschedule_email_message]).deliver if params[:send_reschedule_notification] == "1"
      return true
    end
    false
  end
  
  def cancel_resource_migration(resource_id)
    event = migration_events.where(:resource_id => resource_id).first
    if event
      ResourceMigrationEvent.delete(event)
      return true
    end
    false
  end
  
  def reschedule_user_migration(params)
    return false unless cancel_user_migration(params)
    Migration.find(params[:migration_id]).add_user(User.find(params[:user_id]),params[:skip_notifications])
    true
  end
  
  def send_two_week_email
    users_to_notify = user_migration_events.with_state(:pending)
    users_to_notify.each { |e| e.notify_at_two_weeks }
    users_to_notify.size
  end
  
  def send_one_week_email
    users_to_notify = user_migration_events.with_state(:two_week_notification_sent)
    users_to_notify.each { |e| e.notify_at_one_week }
    users_to_notify.size
  end

  def send_day_before_email
    users_to_notify = user_migration_events.with_state(:one_week_notification_sent)
    users_to_notify.each { |e| e.notify_day_before }
    users_to_notify.size
  end
  
  def self.available_dates(exclude_date=nil)
    avail = where("date >= '#{Date.today}'").select { |m| m.max_accounts > m.migration_events.size }
    avail = avail.select { |d| d.date != exclude_date } if exclude_date
    avail.map { |m| ["#{m.date} - #{m.display_migration_types}", m.id] }
  end
  
  private
  
  def valid_date
    the_date = Chronic.parse(date)
    errors.add(:date, "must be a valid future date") if (the_date.nil? || the_date.to_date < Date.today)
  end

end
