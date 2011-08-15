class GroupsController < ApplicationController

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params[:group])
    if @group.save
      flash[:notice] = "New group created. #{@group.members_added} members added."
      send_to_group
    else
      render :new
    end
  end

  def show
    @group = Group.includes([:users]).find(params[:id])
    @members = @group.members
    @contacts = @group.contacts
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      self.send(params[:group][:action])
    else
      render :show
    end
  end

  private

  def add_deptclass
    flash[:notice] =  "#{@group.members_added} member" + 
                      "#{@group.members_added == 1 ? '' : 's'} added to group."
    send_to_group
  end

  def remove_deptclass
    flash[:notice] =  "#{@group.members_removed} member" + 
                      "#{@group.members_removed == 1 ? '' : 's'} removed from group."
    send_to_group
  end

  def remove_member
    flash[:notice] =  "Member was removed from group."
    send_to_group
  end

  def send_to_group
    redirect_to group_path(@group)
  end
end
