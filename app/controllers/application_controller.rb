class ApplicationController < ActionController::Base
  before_filter :authenticate

  helper :all
  helper_method :current_user, :logged_in?
  hide_action :current_user, :current_user=, :logged_in?, :authenticate
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  def current_user
    @_current_user ||= user_from_session
  end

  def current_user=(user)
    session[:user_id] = user.id
    session[:is_admin] = user.is_admin?
    @_current_user = user
  end

  def logged_in?
    ! current_user.nil?
  end

  def authenticate
    send_to_login unless logged_in?
  end

  protected

  def send_to_login
    store_location
    redirect_to(login_path)
    return false
  end

  def store_location
    if request.get?
      session[:return_url] = request.fullpath
    end
  end

  def user_from_session
    if session[:user_id]
      User.find(session[:user_id])
    end
  end
end
