class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true, :options => "ENGINE=MyISAM" do |t|
      t.integer     :uid
      t.string      :name
      t.string      :firstname
      t.string      :initials
      t.string      :lastname
      t.string      :deptclass
      t.date        :expire_on
      t.string      :state
      t.string      :type
      t.references  :group

      t.timestamps
    end

    add_index :users, :uid
    add_index :users, :firstname
    add_index :users, :lastname
    add_index :users, :expire_on
    add_index :users, :state
    add_index :users, :type
  end

  def self.down
    remove_index :users, :uid
    remove_index :users, :firstname
    remove_index :users, :lastname
    remove_index :users, :expire_on
    remove_index :users, :state
    remove_index :users, :type
    drop_table :users
  end
end
