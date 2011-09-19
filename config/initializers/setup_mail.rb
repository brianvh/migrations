require 'development_mail_interceptor'

ActionMailer::Base.smtp_settings = {
    :address => "mailhub.dartmouth.edu", 
    :port => 25, 
    :domain => "dartmouth.edu",
    } 

ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) unless Rails.env.production?
