class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # before_filter :any_provider
  
  # def facebook
  # end
  
  # def twitter
  # end
  
  # def open_id
  # end
  
  # def google_open_id
  # end


  protected

    def method_missing(method_name, *args)
      debugger
      # if scope.respond_to? method_name
      #   omniauth_authorize method_name, *args
      # else
        super method_name, *args
      # end
  end


  # def any_provider
  #   user = User.find_for_omniauth(env["omniauth.auth"], current_user)
  #   if current_user && params[:return_to]
  #     redirect_to params[:return_to]
  #   else
  #     flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => env["omniauth.auth"]["provider"]
  #     sign_in_and_redirect user, :event => :authentication
  #   end
    
  # end
  
end
