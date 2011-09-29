class AddEmailAssignenetidColsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :email, :string
    add_column :users, :assignednetid, :string
  end

  def self.down
    remove_column :users, :assignednetid
    remove_column :users, :email
  end
end
