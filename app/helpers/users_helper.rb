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
  
end