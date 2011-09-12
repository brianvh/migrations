class Migration < ActiveRecord::Base
  
  default_scope order("date DESC")
  
  has_many :migration_events
  has_many :users, :through => :migration_events
  has_many :resources, :through => :migration_events
  
  validates_presence_of :date, :on => :create, :message => "can't be blank"
  
end