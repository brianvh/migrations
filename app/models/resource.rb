class Resource < ActiveRecord::Base
  has_many :memberships
  has_many :groups, :through => :memberships

  belongs_to :primary_owner, :class_name => "User", :foreign_key => "primary_owner_id"
  belongs_to :secondary_owner, :class_name => "User", :foreign_key => "secondary_owner_id"

  attr_accessor :secondary_owner_name

  validate :valid_or_no_secondary_owner

  before_save :set_secondary_owner

  def primary_owner_name
    primary_owner.nil? ? "" : primary_owner.last_first
  end
  
  def display_secondary_owner_name(last_first=false)
    return "" unless secondary_owner
    last_first ? secondary_owner.last_first : secondary_owner.name
  end
  
  def valid_or_no_secondary_owner
    return if secondary_owner_name.blank?
    return unless lookup_secondary_owner_name.nil?
    bad_secondary_owner_name
    false
  end

  def lookup_secondary_owner_name
    @lookup ||= User.lookup_by_name(secondary_owner_name)
  end

  def bad_secondary_owner_name
    errors.add(:secondary_owner_name, %("#{secondary_owner_name}" is not a unique match in the DND.))
  end
  
  def set_secondary_owner
    self.secondary_owner = secondary_owner_name.blank? ? nil : lookup_secondary_owner_name
  end

end
