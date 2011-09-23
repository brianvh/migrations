class MigrationsController < ApplicationController
  layout 'wide'
  before_filter :admin_user?
  
  def index
    @migrations = Migration.all
  end
  
  def show
    @migration = Migration.find(params[:id])
    if show_accounts? || show_info?
      @accounts = @migration.users_sorted
    elsif show_resources?
      @resources = @migration.resources_sorted
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

  def show_accounts?
    params[:view] == 'accounts'
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
  
  private
  
  def admin_user?
    return true if current_user.is_admin?
    redirect_to user_path(current_user)
  end

  def send_to_migration
    redirect_to migration_path(@migration)
  end
  
  def cancel_user_migration
    if @migration.cancel_user_migration(params[:migration][:user_id])
      flash[:notice] = "Migration successfully canceled."
    end
    redirect_to user_path(params[:migration][:user_id])
  end
  
  def reschedule_user_migration
    if @migration.reschedule_user_migration(params[:migration][:user_id], params[:migration][:migration_id])
      flash[:notice] = "Migration successfully rescheduled."
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

end