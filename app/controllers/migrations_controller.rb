class MigrationsController < ApplicationController
  layout 'wide'
  
  before_filter :admin_user?, :except => [:index, :show]
  
  def index
    send_to_current_user and return unless current_user.is_tech?
    @migrations = Migration.all
  end
  
  def show
    send_to_current_user and return unless current_user.is_tech?
    @migration = Migration.find(params[:id])
    if params[:view].nil?
      case 
      when current_user.is_admin?
        params[:view] = 'accounts'
      when current_user.is_tech?
        params[:view] = 'export'        
      end
    end

    case 
    when show_accounts?, show_info?
      @accounts = @migration.users
    when show_resources?
      @resources = @migration.resources
    when show_export?
      @accounts = @migration.migration_events.sort do |a, b|
        (a.is_a?(UserMigrationEvent) ? a.user.name : a.resource.name) <=> (b.is_a?(UserMigrationEvent) ? b.user.name : b.resource.name)
      end
    end

    respond_to do |wants|
      wants.html
      wants.csv do
        csv = ''
        csv << CSV.generate_line(MigrationEvent.export_header) + "\r\n"
        @accounts.each { |act| csv << CSV.generate_line(act.export) + "\r\n" }
        send_data(csv, :filename => "#{@migration.date}_migration.csv")
      end
    end

  end
  
  def new
    @migration = Migration.new
  end
  
  def create
    @migration = Migration.new(params[:migration])
    if @migration.save
      flash[:notice] = "New migration created."
      redirect_to migrations_path
    else
      flash.now[:error] = "Error creating migration"
      render :new
    end
  end

  def edit
    @migration = Migration.find(params[:id])
  end

  def update
    @migration = Migration.find(params[:id])
    if @migration.update_attributes(params[:migration])
      if params[:migration][:action]
        self.send(params[:migration][:action])
      else
        send_to_migration
      end
    else
      flash.now[:error] = "Error updating migration"
      render :edit
    end
  end
  
  def destroy
    @migration = Migration.find(params[:id])
    if @migration
      @migration.delete_events_and_self
      flash[:notice] = "Migration for #{@migration.date} successfully removed."
    end
    redirect_to migrations_path
  end

  def show_accounts?
    params[:view] == 'accounts' # || params[:view].nil?
  end
  helper_method :show_accounts?
  
  def show_resources?
    params[:view] == 'resources'
  end
  helper_method :show_resources?
  
  def show_info?
    params[:view].nil?
  end
  helper_method :show_info?
  
  def show_export?
    params[:view] == 'export'
  end
  helper_method :show_export?
  
  private
  
  def admin_user?
    return true if current_user.is_admin?
    send_to_current_user
  end

  def admin_or_tech_user?
    return true if current_user.is_tech?
    send_to_current_user
  end

  def send_to_migration
    redirect_to migration_path(@migration)
  end
  
  def send_to_current_user
    redirect_to user_path(current_user)
  end
  
  def cancel_user_migration
    if @migration.cancel_user_migration(params[:migration])
      msg = "Migration successfully cancelled"
      msg += " and the user has been notified." if params[:migration][:send_cancel_notification] == "1"
      msg += " and the user was NOT notified." if params[:migration][:send_cancel_notification] == "0"
      flash[:notice] = msg
    end
    redirect_to user_path(params[:migration][:user_id])
  end
  
  def cancel_resource_migration
    if @migration.cancel_resource_migration(params[:migration][:resource_id])
      flash[:notice] = "Migration successfully cancelled."
    end
    redirect_to resource_path(params[:migration][:resource_id])
  end
  
  def reschedule_user_migration
    if @migration.reschedule_user_migration(params[:migration])
      msg = "Migration successfully rescheduled"
      msg += " and the user has been notified." if params[:migration][:send_reschedule_notification] == "1"
      msg += " and the user was NOT notified." if params[:migration][:send_reschedule_notification] == "0"
      flash[:notice] =  msg
    end
    redirect_to user_path(params[:migration][:user_id])
  end

  def send_two_week_email
    count_sent = @migration.send_two_week_email
    flash[:notice] = "#{count_sent} 2-Week Notification#{(count_sent == 0 || count_sent > 1) ? 's' : ''} sent."
    send_to_migration
  end
  
  def send_one_week_email
    count_sent = @migration.send_one_week_email
    flash[:notice] = "#{count_sent} 1-Week Notification#{(count_sent == 0 || count_sent > 1) ? 's' : ''} sent."
    send_to_migration
  end

  def send_day_before_email
    count_sent = @migration.send_day_before_email
    flash[:notice] = "#{count_sent} 1-Day Notification#{(count_sent == 0 || count_sent > 1) ? 's' : ''} sent."
    send_to_migration
  end
  
  def send_followup_email
    count_sent = @migration.send_followup
    flash[:notice] = "#{count_sent} Followup Notification#{(count_sent == 0 || count_sent > 1) ? 's' : ''} sent."
    send_to_migration
  end

end