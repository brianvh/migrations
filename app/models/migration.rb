class Migration < ActiveRecord::Base
  
  default_scope order("date")

  has_many :migration_events
  
  has_many :user_migration_events
  has_many :users, :through => :user_migration_events
  
  has_many :devices, :through => :users, :source => :devices
  
  has_many :resource_migration_events
  has_many :resources, :through => :resource_migration_events
  
  validates :two_week_email,
            :day_before_email,
            :presence => true
  
  validates :date,
            :uniqueness => { :message => "there is already a migration established for that day" },
            :on => :create
            
  validates :max_accounts,
            :numericality => { :greater_than_or_equal_to => 0, :only_integer => true }
  
  validate :valid_date
  
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
    resources << user.resources_to_migrate
    resources.flatten
  end
  
  def add_user(new_user)
    users << new_user if new_user.needs_migration?
  end
  
  def week_of
    date.beginning_of_week
  end
  
  def self.available_dates
    Migration.where("date >= '#{Date.today}'").select { |m| m.max_accounts > m.migration_events.size }.map { |m| [m.date, m.id] }
  end

  private
  
  def valid_date
    the_date = Chronic.parse(date)
    errors.add(:date, "must be a valid future date") if (the_date.nil? || the_date.to_date < Date.today)
  end

end
