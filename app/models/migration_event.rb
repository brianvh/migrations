class MigrationEvent < ActiveRecord::Base
  
  belongs_to :migration
  has_many :users
  has_many :resources
  
end