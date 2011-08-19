class AddResourceIdToMemberships < ActiveRecord::Migration
  def self.up
    add_column :memberships, :resource_id, :integer
  end

  def self.down
    remove_column :memberships, :resource_id
  end
end
