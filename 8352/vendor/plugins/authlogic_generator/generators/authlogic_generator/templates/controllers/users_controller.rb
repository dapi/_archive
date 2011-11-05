class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update, :index]

  def new
    @user = User.new
  end

  def create
    <% if options[:skip_activation] -%>
      @user = User.new(params[:user])
      if @user.save
        flash[:notice] = "Your account has been created!"
        redirect_to user_path(@user)
      else
        flash[:error] = "User already exists!"
        render :action => :new
      end
    <% else -%>
      @user = User.find_by_email(params[:user][:email]) || User.new(params[:user])
      if @user.active?
        flash[:error] = "User already exists and has been activated."
        render :action => :new
      else
        @user.attributes = params[:user] unless @user.new_record?
        if @user.save_without_session_maintenance
          @user.deliver_activation_instructions!
          flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
          redirect_to new_user_session_path
        else
          render :action => :new
        end
      end
    <% end %>
  end

  def show
    @user = User.find(params[:id])
    <% unless options[:skip_activation] %>
      raise ActiveRecord::RecordNotFound unless @user.active?
    <% end %>
    respond_to do |format|
      format.html {
        if @user == @current_user
          render :action => 'private'
        else
          render :action => 'public'
        end
      }
    end
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to user_url
    else
      render :action => :edit
    end
  end
end
