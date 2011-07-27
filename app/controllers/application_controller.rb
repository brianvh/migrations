class ApplicationController < ActionController::Base
  before_filter :authenticated?

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  protected

  def authenticated?
    unless session[:user_id]
      session[:return_url] = request.url
      redirect_to(login_path)
      return false
    end
  end
end
