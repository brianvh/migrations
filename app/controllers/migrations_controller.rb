class MigrationsController < ApplicationController
  layout 'wide'
  before_filter :admin_user?
  
  def index
    @migrations = Migration.all
  end
  
  def show
    @migration = Migration.find(params[:id])
  end
  
  def new
    @migration = Migration.new
  end
  
  def create
    @migration = Migration.new(params[:migration])
    if @migration.save
      flash[:notice] = "New migration created."
      redirect_to :index
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
      send_to_migration
    else
      flash.now[:error] = "Error updating migration"
      render :edit
    end
  end
  
  private
  
  def admin_user?
    return true if current_user.is_admin?
    send_to_user
  end

  def send_to_migration
    redirect_to migration_path(@migration)
  end

end