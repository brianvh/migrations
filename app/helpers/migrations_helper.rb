module MigrationsHelper
  
  def link_to_profile(user)
    p_state = user.profile_state
    return p_state unless p_state =~ /incomplete|submitted/i
    link_to p_state, profile_path(user.profiles.first)
  end
  
end