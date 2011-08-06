class AddCarrierColToDevice < ActiveRecord::Migration
  def self.up
    add_column :devices, :carrier, :string
  end

  def self.down
    remove_column :devices, :carrier
  end
end
