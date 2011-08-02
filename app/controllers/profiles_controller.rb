class ProfilesController < ApplicationController

  def show
    # @user = User.find(params[:id])
    @user = User.find(session[:user_id])
    @profile = @user.profiles.first
  end
  
  def new
    @user = User.find(session[:user_id])
    @profile = Profile.new
  end
  
  def create
    @user = User.find(session[:user_id])
    @profile = Profile.new(params[:profile])
    if @profile.save
      @user.profiles << @profile
      flash[:notice] = "Successfully created Profile."
      redirect_to profile_path @profile
    else
      render :action => 'new'
    end
    
  end

end