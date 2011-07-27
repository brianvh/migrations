class SessionsController < ApplicationController
  skip_before_filter :authenticated?

  def new
    return_or_root if session[:user_id]
  end

  def create
    if user = User.authenticate(env['omniauth.auth']) # login a known user
      session[:user_id] = user.id
      session[:is_admin] = user.is_admin?
      return_or_root
    else # Unknown users need to register
      session[:user_id] = 0 # User is authenticated, but unregistered
      redirect_to new_user_path(:name => env['omniauth.auth']['extra']['name'])
    end
  end

  def destroy
    reset_session
    app = 'BlitzMail Migration Tracking'
    url = case Rails.env
      when 'staging' then 'http://migrations.webapps.dartmouth.edu/'
      when 'production' then 'https://migrations.dartmouth.edu/'
    else
      'http://migrations.local/'
    end
    redirect_to "https://login.dartmouth.edu/logout.php?app=#{app}&url=#{url}"
  end

  private

  def return_or_root
    redirect_to session[:return_url] || root_path
  end
end
