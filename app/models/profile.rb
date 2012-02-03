class Profile < ActiveRecord::Base

  belongs_to :user
  
  attr_accessor :used_email_choices
  
  serialize :used_email_clients
                      
  before_save :nullify_boolean_attributes
  
  state_machine :initial => :submitted do
    
    event :reviewed do
      transition :submitted => :reviewed
    end
    
    event :reset do
      transition all => :submitted
    end
    
  end

  def used_email_choices=(choices)
    unless choices.nil?
      choices.delete("") # remove blank hidden field
      unless choices.empty?
        return self.used_email_clients = choices
      end
    end
    self.used_email_clients = []
  end

  def used_only_blitz?
    return false if used_email_clients.nil? || used_email_clients.empty? || used_email_clients.size > 1
    return false if (used_email_clients.first =~ /blitz/i).nil?
    return true
  end
  
  def missing_vital_attributes?
    return true if used_email_clients.nil? || used_email_clients.empty?
    boolean_attributes.each do |attribute|
      return true if self[attribute].nil?
    end
    false
  end

  private
  
  def nullify_boolean_attributes    
    boolean_attributes.each do |attribute|
      unless self[attribute] == false
        self[attribute] = nil if self[attribute].blank?
      end
    end
  end
  
  def boolean_attributes
    # [:migrate_oracle_calendar, :uses_mail_forward, :uses_local_mail,
    #  :uses_ira, :uses_hyperion, :used_other_calendars]
    [:migrate_oracle_calendar, :uses_mail_forward, :uses_local_mail, :used_other_calendars]
  end

end
