module UsersHelper

  def links_to_groups(user)
    group_list = []
    user.groups.uniq.each do |g|
      if current_user.can_access_group?(g)
        group_list << link_to(g.name, group_path(g))
      else
        group_list << g.name
      end
    end
    group_list.join(", ").html_safe
  end
  
  def link_to_migration_date
    if current_user.is_admin?
    else
      user_migration_schedule_date(user)
    end
  end
  
  def user_migration_schedule_date(user)
    case 
    when user.has_migration?
      link_text = user.migdate
      return link_to link_text, migration_path(user.migrations.first) if current_user.is_admin?
    when user.needs_migration?
      link_text = "Unscheduled"
    when user.do_not_migrate?
      link_text = "DO NOT MIGRATE"
    else
      link_text = "Completed"
    end
    link_text
  end
  
  def block_migration_link_label(user)
    "#{user.do_not_migrate? ? "Unblock" : "Block"} Migration"
  end

end