class UsersController < ApplicationController

  def index
    redirect_to user_path(current_user)
  end

  def show
    @user = User.find(params[:id])
  end

end