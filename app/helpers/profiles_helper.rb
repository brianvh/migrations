module ProfilesHelper

  def email_clients_display_string(profile)
    return "" if profile.used_email_clients.blank?
    profile.used_email_clients.split(/, ?/).join(", ")
  end

end