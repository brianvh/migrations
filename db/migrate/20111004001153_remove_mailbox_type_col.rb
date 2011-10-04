class RemoveMailboxTypeCol < ActiveRecord::Migration
  def self.up
    remove_column :users, :mailboxtype
  end

  def self.down
    add_column :users, :mailboxtype, :string
  end
end
