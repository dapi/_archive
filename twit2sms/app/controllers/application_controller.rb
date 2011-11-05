# -*- coding: utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  include Authentication

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  
#  private
  


  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # TODO ПОсмотреть что за logged_in? и другие в Authentication
  
#   def redirect_to_root
#     redirect_to(root_path)
#   end

#   def redirect_to_login
#     redirect_to(root_path)
#   end

    
 
end
