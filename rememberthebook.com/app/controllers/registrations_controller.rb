# -*- coding: utf-8 -*-
class RegistrationsController < Devise::RegistrationsController

  helper Devise::OmniAuth::UrlHelpers

  # def create
  #   # add custom create logic here
  # end

  # POST /resource/sign_up
  def create
    
    # super
    build_resource
    
    #Added from railscasts for omniauth
    # session[:omniauth] = nil unless @user.new_record?
    
    # if session[:omniauth]
    #     @user.apply_omniauth(session[:omniauth])
    #     @user.valid?
    # end
    
    if resource.save
      if resource.active?
        set_flash_message :notice, :signed_up
        sign_in_and_redirect(resource_name, resource)
      else
        set_flash_message :notice, :inactive_signed_up, :reason => resource.inactive_message.to_s
        redirect_to after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords(resource)
      # TODO Как бы сделать это интернационально?
      if resource.errors[:email].include? 'уже существует'
        if User.find_by_email( resource.email ).normal?
          set_flash_message :notice, :exist
          redirect_to new_user_session_path :user=>{ :email=>resource.email }
        else
          set_flash_message :notice, :exist_virtual
          redirect_to :controller=>:passwords, :action => :new, :email=>resource.email
        end
        
      else
        render_with_scope :new
      end
    end
  end


end
