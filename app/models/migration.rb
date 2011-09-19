class Migration < ActiveRecord::Base
  
  default_scope order("date")

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
  
  def add_users_and_resources(new_users)
    new_users.each do |new_user|
      user = User.find(new_user)
      add_user(user)
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
  
  def add_user(new_user)
    if new_user.needs_migration?
      users << new_user
      self.users_added += 1
    end
  end
  
  def week_of
    date.beginning_of_week
  end
  
  def cancel_user_migration(user_id)
    event = migration_events.where(:user_id => user_id).first
    if event
      migration_events.where(:user_id => user_id).first.delete
      return true
    end
    false
  end
  
  def reschedule_user_migration(user_id, migration_id)
    cancel_user_migration(user_id)
    Migration.find(migration_id).add_user(User.find(user_id))
    true
  end
  
  def self.available_dates
    where("date >= '#{Date.today}'").select { |m| m.max_accounts > m.migration_events.size }.map { |m| [m.date, m.id] }
  end

  private
  
  def valid_date
    the_date = Chronic.parse(date)
    errors.add(:date, "must be a valid future date") if (the_date.nil? || the_date.to_date < Date.today)
  end

end
