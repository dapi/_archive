class ActivationsController < ApplicationController
  access_control do
     allow anonymous
  end

  def new
    @user = User.find_using_perishable_token(params[:activation_code], 100.year)
    if !@user.nil? && !@user.active? && @user.activate!
      @user.deliver_activation_confirmation!
      UserSession.create(@user)
      flash[:notice] = "Account activated!"
      redirect_to root_url
    else
      flash[:error] = "Account can't be activated!"
      redirect_to new_user_session_path
    end
  end
  
end