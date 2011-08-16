class ResourcesController < ApplicationController
  
  def index
    if current_user.is_support?
      @resources = Resource.all
    else
      @resources = current_user.primary_resource_ownerships
    end
    render :layout => "wide"
  end

  def show
    if current_user.is_support?
      @resource = Resource.find(params[:id])
    else
      @resource = current_user.primary_resource_ownerships.find(params[:id])
      redirect_to user_path if @resource.nil?
    end
  end

  def edit
    if current_user.is_support?
      @resource = Resource.find(params[:id])
    else
      @resource = current_user.primary_resource_ownerships.find(params[:id])
      redirect_to user_path if @resource.nil?
    end
  end

  def update
    if current_user.is_support?
      @resource = Resource.find(params[:id])
    else
      @resource = current_user.primary_resource_ownerships.find(params[:id], :readonly => false)
      redirect_to user_path and return if @resource.nil?
    end
    if @resource.update_attributes(params[:resource])
      redirect_to @resource, :notice  => "Successfully updated resource."
    else
      render :action => 'edit'
    end
  end

  def destroy
    # redirect_to user_path current_user and return unless current_user.is_support?
    @resource = Resource.find(params[:id])
    @resource.destroy
    redirect_to resources_url, :notice => "Successfully destroyed resource."
  end
end
