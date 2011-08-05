class SessionsController < ApplicationController
  skip_before_filter :authenticate

  def new
    return_or_root if logged_in?
  end

  def create
    return send_to_403 if authenticator.nil?
    if user = User.authenticate(authenticator)
      self.current_user = user
      return_or_root
    else
      self.current_user = User.create(:uid => authenticator.uid)
      redirect_to user_path(self.current_user)
    end
  end

  def not_authorized
    render :template => "not_authorized", :status => 403
  end

  def destroy
    reset_session
    send_to_logout
  end

  private

  def return_or_root
    redirect_to session[:return_url] || root_path
  end

  def authenticator
    @authenticator ||= Authenticator.from_hash(auth_hash)
  end

  def auth_hash
    env['omniauth.auth']
  end

  def send_to_403
    redirect_to not_authorized_path
  end

  def app_name
    'migrations'
  end

  def app_title
    'BlitzMail Migration Tracking'
  end

  def app_url
    "http://#{app_name}." << case env_to_sym
      when :development then 'local/'
      when :staging     then 'webapps.dartmouth.edu/'
      when :production  then 'dartmouth.edu/'
    end
  end

  def env_to_sym
    Rails.env.to_sym
  end

  def logout_url
    "https://login.dartmouth.edu/logout.php?app=#{app_title}&url=#{app_url}"
  end

  def send_to_logout
    redirect_to logout_url
  end
end
