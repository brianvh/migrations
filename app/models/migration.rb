class Migration < ActiveRecord::Base
  
  default_scope order("date")
  
  has_many :user_migration_events
  has_many :users, :through => :user_migration_events
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
  
  private
  
  def valid_date
    d = Chronic.parse(date)
    errors.add(:date, "must be a valid future date") if (d.nil? || d.to_date < Date.today)
  end

end