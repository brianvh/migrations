class ProfilesController < ApplicationController

  def show
    @profile = Profile.find(params[:id])
    can_access
  end
  
  def new
    @profile = Profile.new :user => current_user
  end
  
  def create
    @profile = Profile.new(params[:profile])
    if @profile.save
      current_user.profiles << @profile
      incomplete_warning("created")
      redirect_to @profile
    else
      flash.now[:error] = "Error creating Profile."
      render :action => 'new'
    end
  end
  
  def edit
    @profile = Profile.find(params[:id])
    can_access
  end

  def update
    @profile = Profile.find(params[:id])
    can_access
    if @profile.update_attributes(params[:profile])
      incomplete_warning("updated")
      redirect_to @profile
    else
      flash.now[:error] = "Error updating Profile."
      render :action => 'edit'
    end
  end

  def incomplete_warning(new_or_update)
    flash[:notice] = "Successfully #{new_or_update} Profile." unless @profile.missing_vital_attributes?
    flash[:error] = "Profile is incomplete. Provide all information as soon as possible." if @profile.missing_vital_attributes?
  end

  private
  
  def can_access
    unless current_user.is_support? || current_user.can_access_groups_for?(@profile.user)
      redirect_to user_path current_user unless @profile.user_id == current_user.id
    end
  end

end