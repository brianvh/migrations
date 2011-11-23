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
    @resource = Resource.find(params[:id])
    redirect_to user_path unless current_user.is_support? || current_user.can_access_groups_for?(@resource.primary_owner) || !current_user.primary_resource_ownerships.find(params[:id])
  end

  def edit
    @resource = Resource.find(params[:id])
    redirect_to user_path unless current_user.is_support? || current_user.can_access_groups_for?(@resource.primary_owner) || !current_user.primary_resource_ownerships.find(params[:id])
  end

  def update
    @resource = Resource.find(params[:id])
    unless current_user.is_support? || current_user.can_access_groups_for?(@resource.primary_owner)
      redirect_to user_path and return if current_user.primary_resource_ownerships.find(params[:id], :readonly => false) == nil
    end

    if @resource.update_attributes(params[:resource].merge(:primary_owner_name => @resource.primary_owner.name))
      redirect_to @resource, :notice  => "Successfully updated resource."
    else
      flash.now[:error] = "Error updating Resource."
      render :action => 'edit'
    end
  end

end
