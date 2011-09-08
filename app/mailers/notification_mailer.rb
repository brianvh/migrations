class NotificationMailer < ActionMailer::Base
  default :from => "help@dartmouth.edu"

  def invite_group(group, recipients, bcc)
    @group = group
    mail(:to => recipients, :bcc => bcc, :subject => "Prepare for New Email System")
  end
  
  def notify_webmaster(subject, msg, recipients)
    @msg = msg
    mail(:from => 'webmaster@dartmouth.edu', :to => recipients, :subject => subject)
  end
  
end
