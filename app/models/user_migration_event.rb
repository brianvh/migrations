class UserMigrationEvent < MigrationEvent

  belongs_to :user
  belongs_to :migration

  state_machine :initial => :pending do
    
    event :notify_at_two_weeks do
      transition :pending => :two_week_notification_sent
    end
    after_transition :on => :notify_at_two_weeks, :do => :deliver_two_week_notification
    
    event :notify_at_two_weeks_quiet do
      transition any - :no_notifications => :two_week_notification_sent
    end
    
    event :notify_at_one_week do
      transition :two_week_notification_sent => :one_week_notification_sent
    end
    after_transition :on => :notify_at_one_week, :do => :deliver_one_week_notification

    event :notify_at_one_week_quiet do
      transition any - :no_notifications => :one_week_notification_sent
    end
    
    event :notify_day_before do
      transition :one_week_notification_sent => :day_before_notification_sent
    end
    after_transition :on => :notify_day_before, :do => :deliver_day_before_notification

    event :notify_day_before_quiet do
      transition any - :no_notifications => :day_before_notification_sent
    end
    
    event :reset do
      transition any => :pending
    end
    
    event :skip_notifications do
      transition any => :no_notifications
    end

    state :pending, :human_name => 'Pending'
    state :two_week_notification_sent, :human_name => '2-Wk Sent'
    state :one_week_notification_sent, :human_name => '1-Wk Sent'
    state :day_before_notification_sent, :human_name => '1-Day Sent'
    state :no_notifications, :human_name => 'No Notifications'
  end

  def deliver_two_week_notification
    unless user.expired?
      if move_type == "imap"
        NotificationMailer.notify_at_two_weeks(user, 'Your BlitzMail Account is Moving SOON!', migration.two_week_email).deliver
      else
        NotificationMailer.notify_at_two_weeks(user, 'Your Exchange/Outlook Account is Moving SOON!', migration.two_week_onprem_email).deliver
      end
    end
  end
  
  def deliver_one_week_notification
    unless user.expired?
      if move_type == "imap"
        NotificationMailer.notify_at_one_week(user, 'IMPORTANT: Your BlitzMail Account Is Moving NEXT WEEK!', migration.one_week_email).deliver
      else
        NotificationMailer.notify_at_one_week(user, 'IMPORTANT: Your Exchange/Outlook Account Is Moving NEXT WEEK!', migration.one_week_onprem_email).deliver
      end
    end
  end

  def deliver_day_before_notification
    unless user.expired?
      if move_type == "imap"
        NotificationMailer.notify_at_one_day(user, 'URGENT: Your BlitzMail Account is Moving TONIGHT!',  migration.day_before_email).deliver
      else
        NotificationMailer.notify_at_one_day(user, 'URGENT: Your Exchange/Outlook Account is Moving TONIGHT!',  migration.day_before_onprem_email).deliver
      end
    end
  end
  
  def cn
    user.name
  end
  
  def assignednetid
    user.assignednetid
  end

  def move_type
    (user.mailboxtype.blank? || user.mailboxtype.downcase == "blitz") ? "imap" : "onprem"
  end

  def include_oc_migration
    return false if user.profiles.empty?
    user.profiles.first.migrate_oracle_calendar.nil? ? false : user.profiles.first.migrate_oracle_calendar
  end

  def emailsuffix
    user.emailsuffix.sub(/^\./,'')
  end

  def resource_owner1
    ""
  end

  def resource_owner2
    ""
  end

  def num_of_messages
    "-1"
  end

  def mailbox_size
    "-1"
  end
  
end
