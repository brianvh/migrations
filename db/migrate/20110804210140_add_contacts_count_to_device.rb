class AddContactsCountToDevice < ActiveRecord::Migration
  def self.up
    add_column :devices, :contacts_count, :string
  end

  def self.down
    remove_column :devices, :contacts_count
  end
end
