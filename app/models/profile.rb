class Profile < ActiveRecord::Base

  belongs_to :user
  
  attr_accessor :used_email_choices

  def used_email_choices=(choices)
    if choices.size == 0
      self.used_email_clients = ''
    else
      self.used_email_clients = choices.join(",")
    end
  end

  def used_only_blitz?
    ec = used_email_clients.split(/, ?/)
    return false if ec.size > 1
    if ec.size == 1 && ec[0] =~ /blitz/i
      return true
    else
      return false
    end
  end

end
