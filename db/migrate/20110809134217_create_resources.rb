class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :name
      t.string :name_other
      t.string :dept
      t.string :dept_group
      t.string :oc_user
      t.boolean :migrate
      t.string :disposition
      t.text :notes
      t.string :affiliation
      t.integer :group_id
      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
