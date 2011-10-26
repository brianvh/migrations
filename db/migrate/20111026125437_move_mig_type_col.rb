class MoveMigTypeCol < ActiveRecord::Migration
  def self.up
    remove_column :groups, :migration_types
    add_column :migrations, :migration_types, :string
  end

  def self.down
    remove_column :migrations, :migration_types
  end
end
