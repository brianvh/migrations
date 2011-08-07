class Profile < ActiveRecord::Base

  belongs_to :user
  
  attr_accessor :used_email_choices
  
  serialize :used_email_clients

  def used_email_choices=(choices)
    if choices.size == 0
      self.used_email_clients = ''
    else
      self.used_email_clients = choices
    end
  end

  def used_only_blitz?
    return false if used_email_clients.size > 1
    return true if used_email_clients.include?('Blitz[Mail]')
    return false
  end

end
