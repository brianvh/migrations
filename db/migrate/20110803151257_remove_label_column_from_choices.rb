class RemoveLabelColumnFromChoices < ActiveRecord::Migration
  def self.up
    remove_column :choices, :label
  end

  def self.down
    add_column :choices, :label, :string
  end
end
