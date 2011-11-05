# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  # include ExceptionNotification::Notifiable


  # before_filter :require_user # require_user will set the current_user in controllers
  # before_filter :set_current_user

  # def set_current_user
  #   User.current = current_user
  # end

private

  
  def redirect_back(default_url = root_path)
    #redirect_to(params[:return_to] || session[:return_to] || default_url)
    redirect_to(params[:return_to] || default_url)
    # session[:return_to] = nil
  end

  def after_sign_in_path_for(resource_or_scope)
    credits_path
    # if resource_or_scope.is_a?(User) && resource_or_scope.can_publish?
    #   publisher_url
    # else
    #   super
    # end
  end

  # def after_sign_out_path_for(resource_or_scope)
  #       root_path
  # end

end
