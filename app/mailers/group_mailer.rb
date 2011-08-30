class GroupMailer < ActionMailer::Base
  default :from => "help@dartmouth.edu"
  
  def invitation(group, user)
    @group = group
    @user = user
    mail(:to => user.email, :subject => "B2B Migration Profile Request") if m.migration_profile.nil?
  end
  
end
