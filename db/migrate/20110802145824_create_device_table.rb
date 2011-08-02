class CreateDeviceTable < ActiveRecord::Migration
  def self.up
    create_table :devices, :force => true do |t|
      t.string :vendor
      t.string :kind
      t.string :type
      t.string :os_version
      t.string :office_version
      t.string :current_email
      t.string :current_browser
      t.string :new_email
      t.timestamps
    end
  end

  def self.down
    drop_table :devices
  end
end
