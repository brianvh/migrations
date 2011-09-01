class AddMailboxtypeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :mailboxtype, :string
  end

  def self.down
    remove_column :users, :mailboxtype
  end
end
