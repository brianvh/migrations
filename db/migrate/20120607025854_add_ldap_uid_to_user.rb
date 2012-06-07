class AddLdapUidToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :ldap_uid, :string
  end

  def self.down
    remove_column :users, :ldap_uid
  end
end