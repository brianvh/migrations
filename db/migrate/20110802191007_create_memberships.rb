class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships, :force => true, :options => "ENGINE=MyISAM" do |t|
      t.references :group
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :memberships
  end
end
