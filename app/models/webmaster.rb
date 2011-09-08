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
  
  def self.send_email(subject, msg)
    recipients = all.map { |wm| wm.email }
    NotificationMailer.notify_webmaster(subject, msg, recipients).deliver
  end
end
