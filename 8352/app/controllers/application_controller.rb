class ApplicationController < ActionController::Base
  include AuthlogicUser
  
  helper :all 
  helper_method :current_user_session, :current_user

  filter_parameter_logging :password, :password_confirmation
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '71f406cf4951a5cd831472bd0b312736'

#  -----------------------------------------------------------------------------
  # TODO Вынести эту заплатку куда следует
  def get_current_city
    City.find_by_name("Чебоксары")
  end
#  -----------------------------------------------------------------------------

  rescue_from ActiveRecord::RecordNotFound,
              ActionController::RoutingError,
              ActionController::UnknownAction,
              :with => :page_not_found

  rescue_from Acl9::AccessDenied, :with => :access_denied

  rescue_from ThinkingSphinx::ConnectionError, :with => :sphinx_error

#  -----------------------------------------------------------------------------

  protected

  def page_not_found
    render 'home/page_not_found', :status => 404
  end

  def access_denied
    if current_user
      render 'home/access_denied', :status => 403
    else
      redirect_to login_path
    end
  end

  def sphinx_error
    # TODO check the interception of this exception
  end

end
