class RenameEmailCol < ActiveRecord::Migration
  def self.up
    rename_column :migrations, :four_week_email, :two_week_email
  end

  def self.down
    rename_column :migrations, :two_week_email, :four_week_email
  end
end
