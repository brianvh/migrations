class Migration < ActiveRecord::Base
  
  default_scope order("date")
  
  has_many :user_migration_events
  has_many :users, :through => :user_migration_events
  
  has_many :devices, :through => :users, :source => :devices
  
  has_many :resource_migration_events
  has_many :resources, :through => :resource_migration_events
  
  validates :four_week_email,
            :one_week_email,
            :day_before_email,
            :day_of_email,
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
  
  def total_devices
    users.inject(0) { |sum, u| sum + u.devices.count }
  end

  def devices
    d = []
    users.each do |user|
      user.devices.each { |dev| d << dev }
    end
  end
  
  def add_users_and_resources(new_users)
    new_users.each do |u|
      add_user(u)
      u.primary_resource_ownerships.each do |c|
        add_resource(c)
      end
    end
  end
  
  def add_user(new_user) # TODO: check validity, too (i.e. already migrated!)
    users << new_user unless user_migration_events.where(:user_id => new_user.id)
  end
  
  def add_resource(new_resource) # TODO: check validity, too (i.e. already migrated!)
    resources << c unless resource_migration_events.where(:resource_id => new_resource.id)
  end
  
  private
  
  def valid_date
    d = Chronic.parse(date)
    errors.add(:date, "must be a valid future date") if (d.nil? || d.to_date < Date.today)
  end

end
