# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  
  # before_filter :authenticate_user!
  # load_and_authorize_resource
  # http://api.rubyonrails.org/classes/ActiveModel/MassAssignmentSecurity/ClassMethods.html

  # before_filter :authenticate_user!# , :only => [:create, :edit,
  # :update, :destroy]

  # def virtual_pass
  #   @user = User.find_by_email params[:email]
  #   @user.remind_pass
  # end

  def token_auth
    # user = find_or_initialize_with_error_by(:reset_password_token, attributes[:reset_password_token])
    # params[:auth_token]
    # resource = User.find_for_token_authentication(:token_authentication_key)
    sign_out(:user)
    authenticate_user!
        #     resource = mapping.to.find_for_token_authentication(authentication_hash)

        # if validate(resource)
        #   resource.after_token_authentication
        #   success!(resource)
        # else
        #   fail(:invalid_token)
        # end

    redirect_to params[:go] || root_path
  end
  
end
