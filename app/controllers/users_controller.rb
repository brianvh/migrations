class UsersController < ApplicationController

  def index
    redirect_to user_path(current_user)
  end

  def show
    @user = User.includes([:profiles, :devices]).find(params[:id])
    @profile = @user.profiles.first
    @devices = @user.devices
  end

end