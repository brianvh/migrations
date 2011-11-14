class AddFollowupSentOnToMigration < ActiveRecord::Migration
  def self.up
    add_column :migrations, :followup_sent_on, :date
  end

  def self.down
    remove_column :migrations, :followup_sent_on
  end
end
