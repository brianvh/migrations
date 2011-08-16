class Resource < ActiveRecord::Base
	belongs_to :group
  belongs_to :primary_owner, :class_name => "User", :foreign_key => "primary_owner_id"
  belongs_to :secondary_owner, :class_name => "User", :foreign_key => "secondary_owner_id"
  
  validates_presence_of :name, :message => "can't be blank"
  
  def primary_owner_name
    primary_owner.nil? ? "" : primary_owner.last_first
  end
  
  def secondary_owner_name
    secondary_owner.nil? ? "" : secondary_owner.last_first
  end
  
end
