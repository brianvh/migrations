module ProfilesHelper

  def email_clients_display_string(profile)
    return "" unless profile.used_email_clients
    profile.used_email_clients.join(", ") || ""
  end

  def boolean_display_as_todo(val)
    return "TODO" if val.nil?
    val ? "Yes" : "No"
  end

end