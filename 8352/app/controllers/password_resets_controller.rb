class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:show, :update]
  before_filter :require_no_user

  access_control do
     allow anonymous
  end

  def index
  end

  def create
    @user = User.find_by_email(params[:email])
    
      if @user && @user.active?
    
        @user.deliver_password_reset_instructions!
        flash[:notice] = "Instructions to reset your password have been emailed to you. " +
        "Please check your email."
        redirect_to new_user_session_path
    
      elsif @user && !@user.active?
        @user.deliver_activation_instructions!
        flash[:error] = 'Activation needed'
        render :action => 'activate'
    
      else
        flash[:notice] = "No user was found with that email address."
        render :action => :index
      end
    
  end

  def show
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.changed? && @user.save
      flash[:notice] = "Password successfully updated"
      redirect_to user_path(@user)
    else
      flash[:error] = 'Password not updated'
      render :action => :show
    end
  end

  private
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "We're sorry, but we could not locate your account." +
      "If you are having issues try copying and pasting the URL " +
      "from your email into your browser or restarting the " +
      "reset password process."
      redirect_to root_url
    end
  end
end
