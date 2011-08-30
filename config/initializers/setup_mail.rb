require 'development_mail_interceptor'

ActionMailer::Base.smtp_settings = {
    :address => "mailhub.dartmouth.edu", 
    :port => 25, 
    :domain => "dartmouth.edu",
    } 

ActionMailer::Base.default_url_options[:host] = case Rails.env
    when :development then 'migrations.local'
    when :staging     then 'migrations.webapp.dartmouth.edu'
    when :production  then 'migrations.dartmouth.edu/'
  end

ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development? || Rails.env.test?
