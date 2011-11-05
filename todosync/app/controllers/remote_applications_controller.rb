class RemoteApplicationsController < ApplicationController
  def index
    @remote_applications = RemoteApplication.all
  end
  
  def show
    @remote_application = RemoteApplication.find(params[:id])
  end
  
  def new
    @remote_application = RemoteApplication.new
  end
  
  def create
    @remote_application = RemoteApplication.new(params[:remote_application])
    if @remote_application.save
      flash[:notice] = "Successfully created remote application."
      redirect_to @remote_application
    else
      render :action => 'new'
    end
  end
  
  def edit
    @remote_application = RemoteApplication.find(params[:id])
  end
  
  def update
    @remote_application = RemoteApplication.find(params[:id])
    if @remote_application.update_attributes(params[:remote_application])
      flash[:notice] = "Successfully updated remote application."
      redirect_to @remote_application
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @remote_application = RemoteApplication.find(params[:id])
    @remote_application.destroy
    flash[:notice] = "Successfully destroyed remote application."
    redirect_to remote_applications_url
  end
end
