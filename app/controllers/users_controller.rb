class UsersController < ApplicationController

  before_filter :support_user?, :except => [:index, :show]

  def index
    redirect_to user_path(current_user)
  end

  def show
    @user = User.includes([:profiles, :devices]).find(params[:id])
    @profile = @user.profiles.first
    @devices = @user.devices
    @resources = @user.primary_resource_ownerships
  end


  def update
    @user = User.find(params[:id]) 
    if @user.update_attributes(params[:user])
     self.send(params[:user][:action])
    else
     redirect_to user_path(@user)
    end
  end

  private

  def support_user?
    return true if current_user.is_support?
    redirect_to user_path(current_user)
  end

  def block_user_migration
    @user.skip_migration
    redirect_to user_path(@user)
  end
  
  def unblock_user_migration
    @user.reset
    redirect_to user_path(@user)
  end
  
end