class GroupsController < ApplicationController

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params[:group])
    if @group.save
      flash[:notice] = "New group created. #{@group.users_added} users added."
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def show
    @group = Group.includes([:users]).find(params[:id])
    @users = @group.users
  end

end
