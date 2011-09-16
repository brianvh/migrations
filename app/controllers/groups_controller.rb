class GroupsController < ApplicationController
  layout 'wide'
  before_filter :support_user?, :except => [:show]

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
    send_to_user unless current_user.can_access_group?(@group)
    
    if schedule_migrations?
      @members = @group.find_for_migrate
    else
      if show_devices?
        @devices = Device.for_group(@group.id)
      else
        @members = @group.members.order('lastname, firstname')
      end
      @contacts = @group.contacts.order('lastname, firstname')
      @consultants = @group.consultants.order('lastname, firstname')
      @calendars = @group.calendars.order('name')
    end
    
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      self.send(params[:group][:action])
    else
      render :show
    end
  end

  def show_devices?
    params[:view] == 'devices'
  end
  helper_method :show_devices?
  
  def schedule_migrations?
    params[:view] == 'migrations'
  end
  helper_method :schedule_migrations?
  
  # def get_migration_dates?
  #   params[:view] == 'get_migration_dates'
  # end
  # helper_method :get_migration_dates?
  # 
  # def choose_migration_date?
  #   params[:view] == 'choose_migration_date'
  # end
  # helper_method :choose_migration_date?

  private

  def support_user?
    return true if current_user.is_support?
    send_to_user
  end

  def add_member
    if @group.member_name_error
      flash[:error] = @group.member_name_error
    else
      flash[:notice] = %(Member "#{@group.member_name}" added to group.)
    end
    send_to_group
  end

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

  def choose_contact
    flash[:notice] = "#{@group.contact_name} added as a Key Contact." unless @group.contact_name.blank?
    send_to_group
  end

  def clear_contact
    flash[:notice] = "#{@group.contact_name} removed as a Key Contact."
    send_to_group
  end

  def choose_consultant
    flash[:notice] = "#{@group.consultant_name} assigned as a Support Consultant." unless @group.consultant_name.blank?
    send_to_group
  end

  def clear_consultant
    flash[:notice] = "#{@group.consultant_name} un-assigned as a Support Consultant."
    send_to_group
  end

  def send_to_group
    redirect_to group_path(@group)
  end

  def send_to_user
    redirect_to user_path(current_user)
    false
  end

  def send_invitations
    @group.send_invitations
    flash[:notice] = "#{@group.invitations_sent} invitation" +
                     "#{@group.invitations_sent == 1 ? '' : 's'} sent."
    send_to_group
  end

  def schedule_migrations
    # @group = Group.find(params[:id])
    @group.schedule_migrations
    send_to_group
  end
end
