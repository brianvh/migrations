class CreateChoices < ActiveRecord::Migration
  def self.up
    create_table :choices do |t|
      t.string :label
      t.string :value
      t.integer :sort_order
      t.string :type
    end
  end

  def self.down
    drop_table :choices
  end
end
