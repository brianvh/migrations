class ProfilesController < ApplicationController

  def show
    @profile = Profile.find(params[:id])
    @user = User.find(session[:user_id])
    unless @user.is_admin?
      redirect_to user_path @user unless @profile.user_id == @user.id
    end
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
      redirect_to @profile
    else
      render :action => 'new'
    end
  end
  
  def edit
    @profile = Profile.find(params[:id])
    @user = User.find(session[:user_id])
    unless @user.is_admin?
      redirect_to user_path @user unless @profile.user_id == @user.id
    end
  end

  def update
    @profile = Profile.find(params[:id])
    @user = User.find(session[:user_id])
    unless @user.is_admin?
      redirect_to user_path @user unless @profile.user_id == @user.id
    end
    if @profile.update_attributes(params[:profile])
      flash[:notice] = "Successfully updated Profile."
      redirect_to @profile
    else
      render :action => 'edit'
    end
  end

end