class UserMigrationEvent < MigrationEvent

  belongs_to :user

  state_machine :initial => :pending do
    
    event :notify_at_two_weeks do
      transition :pending => :two_week_notification_sent
    end
    after_transition :on => :notify_at_two_weeks, :do => :deliver_two_week_notification
    
    event :notify_at_two_weeks_quiet do
      transition any => :two_week_notification_sent
    end
    
    event :notify_day_before do
      transition :two_week_notification_sent => :day_before_notification_sent
    end
    after_transition :on => :notify_day_before, :do => :deliver_day_before_notification

    event :notify_day_before_quiet do
      transition any => :day_before_notification_sent
    end
    
    event :reset do
      transition any => :pending
    end
    
  end

  def deliver_two_week_notification
    
  end

  def deliver_day_before_notification
    
  end
  
end
