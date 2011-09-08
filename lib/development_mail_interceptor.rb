class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "[Migrations App Development] (#{message.to.join(',')}) #{message.subject}"
    message.to = 'alan.german@dartmouth.edu'
    message.bcc = ''
  end
end