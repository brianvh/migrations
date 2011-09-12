class MigrationEvent < ActiveRecord::Base
  
  belongs_to :migration
  belongs_to :user
  belongs_to :resource
  
end