class DevicesController < ApplicationController
  
  def index
    @devices = current_user.devices.order(:type)
  end
  
  def show
    @device = Device.find(params[:id])
    send_to_user_status unless current_user.can_access_device?(@device)
  end
  
  def new
    @device = Device.new_from_type(type_param, :user => current_user)
  end
  
  def create
    @device = Device.new_from_type(type_param, params[:device])
    
    init_other_fields
    
    if @device.save
      current_user.devices << @device
      flash[:notice] = "Successfully created Device."
      redirect_to device_path(@device)
    else
      flash[:error] = "Error creating Device."
      render :action => 'new'
    end
  end
  
  def edit
    @device = Device.find(params[:id])
    send_to_user_status unless current_user.can_access_device?(@device)
  end
  
  def update
    @device = Device.find(params[:id])
    send_to_user_status unless current_user.can_access_device?(@device)

    init_other_fields
    
    if @device.update_attributes(params[:device])
      flash[:notice] = "Successfully updated Device."
      redirect_to device_path(@device)
    else
      flash[:error] = "Error updating Device."
      render :action => 'edit'
    end
  end

  private

  def send_to_user_status
    redirect_to user_path(current_user)
  end

  def type_param
    (params[:type] || params[:device][:type]).downcase.to_sym
  end

  def init_other_fields
    @device.vendor_other = params[:device][:vendor_other]
    @device.kind_other = params[:device][:kind_other]
    @device.os_version_other = params[:device][:os_version_other]
    @device.office_version_other = params[:device][:office_version_other]
    @device.current_email_other = params[:device][:current_email_other]
    @device.current_browser_other = params[:device][:current_browser_other]
    @device.new_email_other = params[:device][:new_email_other]
    @device.carrier_other = params[:device][:carrier_other]
  end

end
