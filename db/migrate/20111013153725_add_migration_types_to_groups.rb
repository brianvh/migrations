class AddMigrationTypesToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :migration_types, :string
  end

  def self.down
    remove_column :groups, :migration_types
  end
end
