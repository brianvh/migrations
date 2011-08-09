class ResourcesController < ApplicationController
  def index
    if current_user.is_support?
      @resources = Resource.all
    else
      @resource = current_user.resources
    end
  end

  def show
    @resource = Resource.find(params[:id])
  end

  def new
    # redirect_to user_path current_user and return unless current_user.is_support?
    @resource = Resource.new
  end

  def create
    # redirect_to user_path current_user and return unless current_user.is_support?
    @resource = Resource.new(params[:resource])
    if @resource.save
      redirect_to @resource, :notice => "Successfully created resource."
    else
      render :action => 'new'
    end
  end

  def edit
    @resource = Resource.find(params[:id])
  end

  def update
    @resource = Resource.find(params[:id])
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
