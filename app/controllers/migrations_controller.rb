class MigrationsController < ApplicationController
  layout 'wide'
  before_filter :support_user?
  
  def index
    @migrations = Migration.all
  end
  
end