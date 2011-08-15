class ProfilesController < ApplicationController

  def show
    @profile = Profile.find(params[:id])
    unless current_user.is_support?
      redirect_to user_path current_user unless @profile.user_id == current_user.id
    end
  end
  
  def new
    @profile = Profile.new :user => current_user
  end
  
  def create
    @profile = Profile.new(params[:profile])
    if @profile.save
      current_user.profiles << @profile
      flash[:notice] = "Successfully created Profile."
      redirect_to @profile
    else
      flash.now[:error] = "Error creating Profile."
      render :action => 'new'
    end
  end
  
  def edit
    @profile = Profile.find(params[:id])
    unless current_user.is_support?
      redirect_to user_path current_user unless @profile.user_id == current_user.id
    end
  end

  def update
    @profile = Profile.find(params[:id])
    unless current_user.is_support?
      redirect_to user_path current_user unless @profile.user_id == current_user.id
    end
    if @profile.update_attributes(params[:profile])
      flash[:notice] = "Successfully updated Profile."
      redirect_to @profile
    else
      flash.now[:error] = "Error updating Profile."
      render :action => 'edit'
    end
  end

end