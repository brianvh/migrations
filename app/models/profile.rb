class Profile < ActiveRecord::Base

  belongs_to :user

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
