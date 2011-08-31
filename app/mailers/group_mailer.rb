class GroupMailer < ActionMailer::Base
  default :from => "help@dartmouth.edu"

  def invitation(group, recipients, bcc)
    @group = group
    mail(:to => recipients, :bcc => bcc, :subject => "B2B Migration Profile Request")
  end
  
end
