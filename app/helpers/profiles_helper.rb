module ProfilesHelper

  def email_clients_display_string(profile)
    if profile.used_email_clients.blank? || profile.used_email_clients.empty?
      "Not yet specified"
    else
      profile.used_email_clients.join(", ") || ""
    end
  end

  def boolean_display_as_todo(val)
    return "Not yet specified" if val.nil?
    val ? "Yes" : "No"
  end

  def email_checkbox(choice, index)
    checked = false
    unless @profile.used_email_clients.nil?
      checked = @profile.used_email_clients.include?(choice["value"]) ? true : false
    end
    check_box_tag("profile[used_email_choices][]", choice["value"], checked, options = {:id => "email_choice_#{index}" } )
  end

end