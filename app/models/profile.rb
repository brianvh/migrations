class Profile < ActiveRecord::Base

  belongs_to :user
  
  attr_accessor :used_email_choices
  
  serialize :used_email_clients

  def used_email_choices=(choices)
    
    unless choices.nil?
      choices.shift # remove blank hidden field
      unless choices.empty?
        return self.used_email_clients = choices
      end
    end
    self.used_email_clients = []

  end

  def used_only_blitz?
    return false if used_email_clients.size > 1
    return true if used_email_clients.grep(/blitz/i)
    return false
  end

end
