class CreateMigrations < ActiveRecord::Migration
  def self.up
    create_table :migrations, :force => true do |t|
      t.date :date
      t.integer :max_accounts
      t.text :four_week_email
      t.text :one_week_email
      t.text :day_before_email
      t.text :day_of_email
      t.timestamps
    end
    
    create_table :migration_events, :force => true do |t|
      t.integer :migration_id
      t.integer :user_id
      t.integer :resource_id
      t.string :type
      t.string :state
      t.timestamps
    end
    
  end

  def self.down
    drop_table :migration_events
    drop_table :migrations
  end
end
