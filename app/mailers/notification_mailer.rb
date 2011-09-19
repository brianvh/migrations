class NotificationMailer < ActionMailer::Base
  
  def invite_group(group, recipients, bcc)
    @group = group
    mail(:from => "help@dartmouth.edu", :to => recipients, :bcc => bcc, :subject => "Prepare for New Email System")
  end
  
  def notify_webmaster(subject, msg, recipients)
    @msg = msg
    mail(:from => 'webmaster@dartmouth.edu', :to => recipients, :subject => subject)
  end

  def notify_at_two_weeks(user, msg)
    @user = user
    @msg = ERB.new(msg.html_safe).result(binding)
    mail(:from => 'e-mail.transition@dartmouth.edu', :to => @user.email, :subject => 'IMPORTANT: Your BlitzMail Account Is Moving!')
  end
  
  def notify_at_one_week(user, msg)
    @user = user
    @msg = ERB.new(msg.html_safe).result(binding)
    mail(:from => 'e-mail.transition@dartmouth.edu', :to => @user.email, :subject => 'IMPORTANT: Your BlitzMail Account Is Moving NEXT WEEK!')
  end
  
  def notify_at_one_day(user, msg)
    @user = user
    @msg = ERB.new(msg.html_safe).result(binding)
    mail(:from => 'e-mail.transition@dartmouth.edu', :to => @user.email, :subject => 'IMPORTANT: Your BlitzMail Account Is Moving TOMORROW!')
  end
  
  def dndname
    @user.name
  end
  
  def newemailaddress
    @user.newemailaddress
  end
  
  def netid
    @user.assignednetid
  end
  
  def migdate
    @user.migration_events.first.migration.date.to_s(:long)
  end

end
