class ModifyResources < ActiveRecord::Migration
  def self.up
    add_column :resources, :primary_owner_id, :integer
    add_column :resources, :secondary_owner_id, :integer
    rename_column :resources, :disposition, :migrate_data
    change_column :resources, :migrate_data, :boolean
  end

  def self.down
    change_column :resources, :migrate_data, :string
    rename_column :resources, :migrate_data, :disposition
    remove_column :resources, :secondary_owner_id
    remove_column :resources, :primary_owner_id
  end
end
