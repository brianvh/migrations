class ResourceMigrationEvent < MigrationEvent
  
  belongs_to :resource
  
  def cn
    resource.name
  end

  def move_type
    "resource"
  end

  def include_oc_migration
    "true"
  end

  def emailsuffix
    ""
  end

  def resource_owner1
    resource.primary_owner.nil? ? "" : resource.primary_owner.name
  end

  def resource_owner2
    resource.secondary_owner.nil? ? "" : resource.secondary_owner.name
  end

  def num_of_messages
    "-1"
  end

  def mailbox_size
    "-1"
  end
  
end
