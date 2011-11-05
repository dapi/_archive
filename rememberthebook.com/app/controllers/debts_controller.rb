# -*- coding: utf-8 -*-
class DebtsController < ApplicationController

  # before_filter :authenticate_

  # load_and_authorize_resource
  
  before_filter :authenticate_user! # , :only => [:create, :edit, :update, :destroy]
  
  #  rescue_from CanCan::AccessDenied do |exception|
  #    flash[:error] = exception.message
  #    # render :file => "#{RAILS_ROOT}/public/403.html", :status => 403
  #    sign_out current_user if user_signed_in?
  #    # pp '-----------'
  #    #redirect_to :back # root_path # new_user_session
  #    redirect_to new_user_session_path
  # end

  def confirm
    @debt = current_user.debts.find(params[:id])
    authorize! :confirm, @debt
    if params[:accept]
      @debt.accept
      redirect_back credits_url
    elsif params[:decline]
      @debt.decline
      redirect_back credits_url
    end
  end
  
  def index
    redirect_to credits_url
    # @debts = current_user.debts.open
    # @closed_debts = current_user.debts.closed
  end
  
  def show
    @debt = current_user.debts.find(params[:id])
    # authorize! :read, @debt
  end
  
  def new
    authorize! :create, Debt
    @debt = Debt.new( :till => Date.today + 7 )
    # TODO Ability
    if params[:partner_id]
      @debt.creditor = User.find(params[:partner_id])
    else
      @debt.build_creditor
    end
  end
  
  def create
    authorize! :create, Debt
    
    # params[:debt][:creditor_attributes].delete(:id) # И зачем formtastic его вставляет?

    # Зачем?
    #params[:debt][:creditor_attributes][:state] = 'nopass'

    
    @debt = current_user.debts.new(params[:debt])
    
    if @debt.save
      flash[:notice] = "Successfully created debt."
      redirect_to credits_url
    else
      flash[:error] = "Более тщательно заполние поля."
      render :action => 'new'
    end
  end

  def close
    @debt = current_user.debts.find(params[:id])
    authorize! :close, @debt
    @debt.close
    flash[:notice] = "Successfully updated debt."
    redirect_back credits_url
  end
  
  def edit
    @debt = current_user.debts.find(params[:id])
    authorize! :edit, @debt
  end

  def update
    @debt = current_user.debts.find(params[:id])
    authorize! :edit, @debt

    # Проверяем какие аттритубы можно менять, а какие нет
    if @debt.update_attributes(params[:debt])
      flash[:notice] = "Successfully updated debt."
      redirect_back @debt
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @debt = current_user.debts.find(params[:id])
    authorize! :destroy, @debt
    
    @debt.destroy
    flash[:notice] = "Successfully destroyed debt."
    redirect_to credits_url
  end
end
