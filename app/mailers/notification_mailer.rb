class NotificationMailer < ActionMailer::Base
  
  def invite_group(group, recipients, bcc)
    @group = group
    @msg = ERB.new(group.invite_msg.html_safe).result(binding)
    mail(:from => "e-mail.transition@dartmouth.edu", :to => recipients, :bcc => bcc, :subject => "Your Blitz Transition is Around the Corner!")
  end
  
  def notify_webmaster(subject, msg, recipients)
    @msg = msg
    mail(:from => 'webmaster@dartmouth.edu', :to => recipients, :subject => subject)
  end

  def notify_at_two_weeks(user, msg)
    @user = user
    @msg = ERB.new(msg.html_safe).result(binding)
    mail(:from => 'e-mail.transition@dartmouth.edu', :to => @user.email, :subject => 'Your BlitzMail Account is Moving SOON!')
  end
  
  def notify_at_one_week(user, msg)
    @user = user
    @msg = ERB.new(msg.html_safe).result(binding)
    mail(:from => 'e-mail.transition@dartmouth.edu', :to => @user.email, :subject => 'IMPORTANT: Your BlitzMail Account Is Moving NEXT WEEK!')
  end
  
  def notify_at_one_day(user, msg)
    @user = user
    @msg = ERB.new(msg.html_safe).result(binding)
    mail(:from => 'e-mail.transition@dartmouth.edu', :to => @user.email, :subject => 'URGENT: Your BlitzMail Account is Moving TONIGHT!')
  end
  
  def notify_on_cancel(user, subject, msg)
    @user = user
    @msg = ERB.new(msg.html_safe).result(binding)
    mail(:from => 'e-mail.transition@dartmouth.edu', :to => @user.email, :subject => subject)
  end
  
  def notify_on_reschedule(user, subject, msg)
    @user = user
    @msg = ERB.new(msg.html_safe).result(binding)
    mail(:from => 'e-mail.transition@dartmouth.edu', :to => @user.email, :subject => subject)
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
    @user.migdate
  end
  
  def migday
    @user.migday
  end
  
  def day_after_migdate
    @user.day_after_migdate
  end

  def week_of_date
    @group.week_of_date
  end

end
