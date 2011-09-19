class MigrationsController < ApplicationController
  layout 'wide'
  before_filter :admin_user?
  
  def index
    @migrations = Migration.all
  end
  
  def show
    @migration = Migration.find(params[:id])
    if show_accounts? || show_info?
      @accounts = @migration.users
    elsif show_resources?
      @resources = @migration.resources
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
    send_to_user
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

end