module UsersHelper

  def links_to_groups(user)
    group_list = []
    user.groups.uniq.each do |g|
      if user.is_contact?(g) || user.is_consultant?(g)
        group_list << link_to(g.name, group_path(g))
      else
        group_list << g.name
      end
    end
    group_list.join(", ")
  end
  
  def migration_schedule_date(user)
    case 
    when user.has_migration?
      user.migrations.first.date.to_s(:long)
    when user.needs_migration?
      "Not yet scheduled"
    when user.do_not_migrate?
      "DO NOT MIGRATE"
    else
      "Completed"
    end
  end
  
  
  def block_migration_link_label(user)
    "#{user.do_not_migrate? ? "Unblock" : "Block"} Migration"
  end

end