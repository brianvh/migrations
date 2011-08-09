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

end