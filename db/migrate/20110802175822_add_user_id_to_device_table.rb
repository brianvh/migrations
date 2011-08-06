class AddUserIdToDeviceTable < ActiveRecord::Migration
  def self.up
    add_column :devices, :user_id, :integer
  end

  def self.down
    remove_column :devices, :user_id
  end
end
