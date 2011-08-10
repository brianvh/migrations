class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups, :force => true, :options => "ENGINE=MyISAM" do |t|
      t.string :name
      t.string :week_of
      t.text :invite_msg

      t.timestamps
    end

    add_index :groups, :name
  end

  def self.down
    remove_index :groups, :name
    drop_table :groups
  end
end
