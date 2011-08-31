class AddSendInvitationColToMemberships < ActiveRecord::Migration
  def self.up
    add_column :memberships, :invitation_sent, :boolean
  end

  def self.down
    remove_column :memberships, :invitation_sent
  end
end
