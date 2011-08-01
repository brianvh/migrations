class FixProfileUsedEmailClientsType < ActiveRecord::Migration
  def self.up
    change_column :profiles, :used_email_clients, :string
  end

  def self.down
    change_column :profiles, :used_email_clients, :boolean
  end
end
