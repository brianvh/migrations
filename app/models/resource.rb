class Resource < ActiveRecord::Base
  
  default_scope order(:name)
  
  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :migration_events
  has_many :migrations, :through => :migration_events

  belongs_to :primary_owner, :class_name => "User", :foreign_key => "primary_owner_id"
  belongs_to :secondary_owner, :class_name => "User", :foreign_key => "secondary_owner_id"

  attr_accessor :primary_owner_name, :secondary_owner_name

  validate :valid_or_no_primary_owner
  validate :valid_or_no_secondary_owner

  before_save :set_owners
  
  def display_primary_owner_name(last_first=false)
    return primary_owner_name unless primary_owner_name.blank?
    return "" unless primary_owner
    last_first ? primary_owner.last_first : primary_owner.name
  end

  def display_secondary_owner_name(last_first=false)
    return secondary_owner_name unless secondary_owner_name.blank?
    return "" unless secondary_owner
    last_first ? secondary_owner.last_first : secondary_owner.name
  end

  def set_owners
    set_primary_owner
    set_secondary_owner
  end
  
  def valid_or_no_primary_owner
    return if primary_owner_name.blank?
    return unless lookup_primary_owner_name.nil?
    bad_primary_owner_name
    false
  end

  def valid_or_no_secondary_owner
    return if secondary_owner_name.blank?
    return unless lookup_secondary_owner_name.nil?
    bad_secondary_owner_name
    false
  end

  def lookup_primary_owner_name
    @primary_lookup ||= User.lookup_by_name(primary_owner_name)
  end

  def lookup_secondary_owner_name
    @secondary_lookup ||= User.lookup_by_name(secondary_owner_name)
  end

  def bad_primary_owner_name
    errors.add(:primary_owner_name, %("#{primary_owner_name}" is not a unique match in the DND.))
  end
  
  def bad_secondary_owner_name
    errors.add(:secondary_owner_name, %("#{secondary_owner_name}" is not a unique match in the DND.))
  end
  
  def set_primary_owner
    self.primary_owner = primary_owner_name.blank? ? nil : lookup_primary_owner_name
  end

  def set_secondary_owner
    self.secondary_owner = secondary_owner_name.blank? ? nil : lookup_secondary_owner_name
  end

  def migration_state
    return migration_events.first.migration.date if has_migration?
    "Unscheduled"
  end
  
  def migdate
    migration_events.first.migration.date
  end
  
  def do_not_migrate?
    primary_owner.nil?
  end
  
  def has_migration?
    migration_events.first
  end
  
  def has_owner?
    primary_owner
  end
  
  def needs_migration?
    return false if do_not_migrate?
    return false if has_migration?
    return false unless migrate?
    true
  end

  def cancel_migration
    ResourceMigrationEvent.delete(migration_events)
  end

end
