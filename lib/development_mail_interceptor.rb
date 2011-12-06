class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "[MITS Testing. Original recipient(s): #{(message.to.nil? ? "" : message.to.join(','))}] #{message.subject}"
    message.to = ['Erik.J.Hindley@dartmouth.edu','alan.s.german@dartmouth.edu']
    unless message.bcc.blank?
      temp = "(bcc recipients: " + message.bcc.join("\n") + ")\n\n"
    else
      temp = ""
    end
    message.body = temp + message.body.raw_source.to_s
    message.bcc = ''
  end
end