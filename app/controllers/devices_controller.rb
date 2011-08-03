class DevicesController < ApplicationController
  
  def index
    @user = User.find(session[:user_id])
    @devices = @user.devices
  end
  
  def show
    @device = Device.find(params[:id])
    @user = User.find(session[:user_id])
    unless @user.is_admin?
      redirect_to user_path @user unless @device.user_id == @user.id
    end
  end
  
  def new
    @user = User.find(session[:user_id])
    @device = Device.new
  end
  
  def create
    @user = User.find(session[:user_id])
    @device = Device.new(params[:device])
    if @device.save
      @user.devices << @device
      flash[:notice] = "Successfully created Device."
      redirect_to devices_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @device = Device.find(params[:id])
    @user = User.find(session[:user_id])
    unless @user.is_admin?
      redirect_to user_path @user unless @device.user_id == @user.id
    end
  end
  
  def update
    @device = Device.find(params[:id])
    @user = User.find(session[:user_id])
    unless @user.is_admin?
      redirect_to user_path @user unless @device.user_id == @user.id
    end
    if @device.update_attributes(params[:device])
      flash[:notice] = "Successfully updated Device."
      redirect_to devices_path
    else
      render :action => 'edit'
    end
  end

end