class UserMigrationEvent < MigrationEvent

  belongs_to :user
  belongs_to :migration

  state_machine :initial => :pending do
    
    event :notify_at_two_weeks do
      transition :pending => :two_week_notification_sent
    end
    after_transition :on => :notify_at_two_weeks, :do => :deliver_two_week_notification
    
    event :notify_at_two_weeks_quiet do
      transition any => :two_week_notification_sent
    end
    
    event :notify_at_one_week do
      transition :two_week_notification_sent => :one_week_notification_sent
    end
    after_transition :on => :notify_at_one_week, :do => :deliver_one_week_notification

    event :notify_at_one_week_quiet do
      transition any => :one_week_notification_sent
    end
    
    event :notify_day_before do
      transition :one_week_notification_sent => :day_before_notification_sent
    end
    after_transition :on => :notify_day_before, :do => :deliver_day_before_notification

    event :notify_day_before_quiet do
      transition any => :day_before_notification_sent
    end
    
    event :reset do
      transition any => :pending
    end

    state :pending, :human_name => 'Pending'
    state :two_week_notification_sent, :human_name => '2-Week'
    state :one_week_notification_sent, :human_name => '1-Week'
    state :day_before_notification_sent, :human_name => '1-Day'
    
  end

  def deliver_two_week_notification
    NotificationMailer.notify_at_two_weeks(user, migration.two_week_email).deliver
  end
  
  def deliver_one_week_notification
    NotificationMailer.notify_at_one_week(user, migration.one_week_email).deliver
  end

  def deliver_day_before_notification
    NotificationMailer.notify_day_before(user, migration.day_before_email).deliver
  end
  
end
