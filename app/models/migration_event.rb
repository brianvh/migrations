class MigrationEvent < ActiveRecord::Base
  
  belongs_to :migration
  
  state_machine :initial => :pending do
    
    event :reset do
      transition any => :pending
    end
    
  end
  
  def migration_state
    state.titlecase
  end
end