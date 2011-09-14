class UserMigrationEvent < MigrationEvent

  belongs_to :user

  state_machine :initial => :pending do
    
    event :notify_at_four_weeks do
      transition :pending => :four_week_notification_sent
    end
    after_transition :on => :four_week_notification_sent, :do => :deliver_four_week_notification
    
    event :notify_at_two_weeks do
      transition :four_week_notification_sent => :two_week_notification_sent
    end
    after_transition :on => :two_week_notification_sent, :do => :deliver_two_week_notification
    
    event :notify_day_before do
      transition :two_week_notification_sent => :day_before_notification_sent
    end
    after_transition :on => :day_before_notification_sent, :do => :deliver_day_before_notification
    
    event :notify_day_of do
      transition :day_before_notification_sent => :day_of_notification_sent
    end
    after_transition :on => :day_of_notification_sent, :do => :deliver_day_of_notification
    
    event :reset do
      transition any => :pending
    end
    
  end

  def deliver_four_week_notification
    
  end

  def deliver_two_week_notification
    
  end

  def deliver_day_of_notification
    
  end

  def deliver_day_before_notification
    
  end
  
end
