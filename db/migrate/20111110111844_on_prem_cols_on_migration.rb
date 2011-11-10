class OnPremColsOnMigration < ActiveRecord::Migration
  def self.up
    add_column :migrations, :two_week_onprem_email, :text
    add_column :migrations, :one_week_onprem_email, :text
    add_column :migrations, :day_before_onprem_email, :text
  end

  def self.down
    remove_column :migrations, :day_before_onprem_email
    remove_column :migrations, :one_week_onprem_email
    remove_column :migrations, :two_week_onprem_email
  end
end
