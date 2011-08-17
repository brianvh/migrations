class Resource < ActiveRecord::Base
	belongs_to :group
  belongs_to :primary_owner, :class_name => "User", :foreign_key => "primary_owner_id"
  belongs_to :secondary_owner, :class_name => "User", :foreign_key => "secondary_owner_id"
  
  attr_accessor :secondary_owner_name
  
  def primary_owner_name
    primary_owner.nil? ? "" : primary_owner.last_first
  end
  
  def secondary_owner_name(last_first=false)
    return "" unless secondary_owner
    last_first ? secondary_owner.last_first : secondary_owner.name
  end
  
  def secondary_owner_name=(name)
    user = User.lookup_by_name(name)
    self.secondary_owner = User.lookup_by_name(name)
  end
  
end
