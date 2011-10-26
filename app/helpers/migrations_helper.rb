module MigrationsHelper
  
  def link_to_profile(user)
    p_state = user.profile_state
    return p_state unless p_state =~ /incomplete|submitted/i
    link_to p_state, profile_path(user.profiles.first)
  end
  
  def migration_type_checkbox(choice, index)
    checked = false
    unless @migration.migration_types.nil?
      checked = @migration.migration_types.include?(choice) ? true : false
    end
    check_box_tag("migration[migration_types_choices][]", choice, checked, options = {:id => "migration_type_#{index}" } )
  end
  
end