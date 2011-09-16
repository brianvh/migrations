class UserMigrationEvent < MigrationEvent

  belongs_to :user

  state_machine :initial => :pending do
    
    event :notify_at_two_weeks do
      transition :pending => :two_week_notification_sent
    end
    after_transition :on => :two_week_notification_sent, :do => :deliver_two_week_notification
    
    event :notify_day_before do
      transition :two_week_notification_sent => :day_before_notification_sent
    end
    after_transition :on => :day_before_notification_sent, :do => :deliver_day_before_notification
    
    event :reset do
      transition any => :pending
    end
    
  end

  def deliver_two_week_notification
    
  end

  def deliver_day_before_notification
    
  end
  
end
