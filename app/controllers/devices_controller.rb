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
    @device_type = params[:type].downcase.titlecase
  end
  
  def create
    @user = User.find(session[:user_id])
    @device = Device.new(params[:device])
    
    init_other_fields
    
    if @device.save
      @user.devices << @device
      flash[:notice] = "Successfully created Device."
      redirect_to devices_path
    else
      @device_type = params[:device][:type]
      render :action => 'new'
    end
  end
  
  def edit
    @device = Device.find(params[:id])
    @device_type = @device.type
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

    init_other_fields
    
    if @device.update_attributes(params[:device])
      flash[:notice] = "Successfully updated Device."
      redirect_to devices_path
    else
      render :action => 'edit'
    end
  end

  def init_other_fields
    @device.vendor_other = params[:device][:vendor_other]
    @device.kind_other = params[:device][:kind_other]
    @device.os_version_other = params[:device][:os_version_other]
    @device.office_version_other = params[:device][:office_version_other]
    @device.current_email_other = params[:device][:current_email_other]
    @device.current_browser_other = params[:device][:current_browser_other]
    @device.new_email_other = params[:device][:new_email_other]
    @device.carrier = params[:device][:carrier_other]
  end

end