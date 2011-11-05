# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
#  include Clearance::App::Controllers::ApplicationController
class ApplicationController < ActionController::Base
  include Clearance::Authentication
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  



  # Scrub sensitive parameters from your log
  
  filter_parameter_logging :password
  
  
  private
  def sign_user_in(user)
    
    # store current time to display "last signed in at" message
    #    p "update user"
    user.update_attribute(:last_signed_in_at, Time.now)
    sign_in(user)
  end

end
