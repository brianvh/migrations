module ResourcesHelper

  def boolean_display(val)
    return "Unspecified" if val.nil?
    val ? "Yes" : "No"
  end

  def resource_migration_schedule_date(resource)
    case 
    when resource.has_migration?
      link_text = resource.migdate
      return link_to link_text, migration_path(resource.migrations.first) if current_user.is_admin?
    when resource.needs_migration?
      link_text = "Unscheduled"
    when resource.do_not_migrate?
      link_text = "Unscheduled"
    else
      link_text = "Pending"
    end
    link_text
  end
  

end
