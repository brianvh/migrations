class UsersController < ApplicationController

  def index
    redirect_to user_path(session[:user_id])
  end

  def show
    @user = User.find(params[:id])
  end

end