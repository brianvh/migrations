module ProfilesHelper

  def email_clients_display_string(profile)
    if profile.used_email_clients.blank? || profile.used_email_clients.empty?
      content_tag(:span, "Unspecified", :style => "font-weight: bold;")
    else
      profile.used_email_clients.join(", ") || ""
    end
  end

  def email_checkbox(choice, index)
    checked = false
    unless @profile.used_email_clients.nil?
      checked = @profile.used_email_clients.include?(choice) ? true : false
    end
    check_box_tag("profile[used_email_choices][]", choice, checked, options = {:id => "email_choice_#{index}" } )
  end

end