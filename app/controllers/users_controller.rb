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
     send_to_user
    end
  end

  private

  def support_user?
    return true if current_user.is_support?
    redirect_to user_path(current_user)
  end

  def block_user_migration
    @user.block_from_migration
    flash[:notice] = "User successfully blocked from migration."
    send_to_user
  end
  
  def unblock_user_migration
    @user.unblock_from_migration
    flash[:notice] = "User successfully unblocked from migration."
    send_to_user
  end
  
  def send_to_user
     redirect_to user_path(@user)
  end
  
end