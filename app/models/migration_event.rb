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
  
  def export
    MigrationEvent.export_field_map.map { |k,v| self.send(v) }
  end
  
  def self.export_field_map
    [
      [ "cn" , :cn ],
      [ "move type" , :move_type ],
      [ "include oc migration" , :include_oc_migration ],
      [ "emailsuffix" , :emailsuffix ],
      [ "resource owner1" , :resource_owner1 ],
      [ "resource owner2" , :resource_owner2 ],
      [ "num of messages" , :num_of_messages ],
      [ "mailbox size" , :mailbox_size ]
    ]
  end
  
  def self.export_header
    self.export_field_map.map { |efm| efm[0] }
  end

end