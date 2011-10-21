class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "[Migrations App Development] (#{message.to.join(',')}) #{message.subject}"
    message.to = 'alan.german@dartmouth.edu'
    message.body = "(bcc: #{message.bcc.join("\n")})\n\n" + message.body.raw_source
    message.bcc = ''
  end
end