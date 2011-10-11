module ProfilesHelper

  def email_clients_display_string(profile)
    if profile.used_email_clients.blank? || profile.used_email_clients.empty?
      content_tag(:span, "Unspecified", :style => "color: red;")
    else
      profile.used_email_clients.join(", ") || ""
    end
  end

  def boolean_display_as_todo(val)
    return content_tag(:span, "Unspecified", :style => "color: red;") if val.nil?
    val ? "Yes" : "No"
  end

  def email_checkbox(choice, index)
    checked = false
    unless @profile.used_email_clients.nil?
      checked = @profile.used_email_clients.include?(choice) ? true : false
    end
    check_box_tag("profile[used_email_choices][]", choice, checked, options = {:id => "email_choice_#{index}" } )
  end

end