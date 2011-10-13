module GroupsHelper
  
  def migration_type_checkbox(choice, index)
    checked = false
    unless @group.migration_types.nil?
      checked = @group.migration_types.include?(choice) ? true : false
    end
    check_box_tag("group[migration_types_choices][]", choice, checked, options = {:id => "migration_type_#{index}" } )
  end
  
end