class Webmaster < User
  def is_support?
    true
  end

  def is_admin?
    true
  end

  def is_webmaster?
    true
  end

  def self.ldap_sync_notify(result)
    msg = "The LDAP sync results were:\n\n"
    msg += result.map { |k,v| "#{k}: #{v}" }.join("\n")
    Webmaster.send_email("Migrations - Nightly LDAP Sync Results", msg)
  end
  
  def self.send_email(subject, msg)
    recipients = all.map { |wm| wm.email }
    NotificationMailer.notify_webmaster(subject, msg, recipients).deliver
  end
end
