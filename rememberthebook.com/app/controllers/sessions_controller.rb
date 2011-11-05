# -*- coding: utf-8 -*-
class SessionsController < Devise::SessionsController

  def create
    if params[:user] and user = User.find_by_email(params[:user][:email]) and !user.normal?
      set_flash_message :notice, :exist_virtual
      redirect_to :controller=>:passwords, :action => :new, :email=>user.email
    else
      resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
      set_flash_message :notice, :signed_in
      sign_in_and_redirect(resource_name, resource)
    end
    # @resource = User.new
    # render{ :action => :new , :object => { :resource => @resource }
    # warden.custom_failure!
    # return
  end

  
end
