class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :msg_count
      t.integer :mbox_size
      t.boolean :migrate_oracle_calendar
      t.boolean :uses_mail_forward
      t.boolean :uses_local_mail
      t.boolean :uses_ira
      t.boolean :uses_hyperion
      t.boolean :used_email_clients
      t.boolean :used_other_calendars
      t.string :comfort_level
      t.boolean :uses_sync
      t.string :complexity_level
      t.boolean :vip
      t.text :support_notes
      t.string :state
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
