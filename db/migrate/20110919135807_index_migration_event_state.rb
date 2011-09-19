class IndexMigrationEventState < ActiveRecord::Migration
  def self.up
    add_index :migration_events, :state
  end

  def self.down
    remove_index :migration_events, :state
  end
end
