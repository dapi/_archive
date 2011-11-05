# -*- coding: utf-8 -*-
class CreditsController < ApplicationController
  
  # before_filter :authenticate_user!
  # load_and_authorize_resource
  # http://api.rubyonrails.org/classes/ActiveModel/MassAssignmentSecurity/ClassMethods.html

  before_filter :authenticate_user!# , :only => [:create, :edit, :update, :destroy]

  # rescue_from CanCan::AccessDenied do |exception|
  #   flash[:error] = exception.message
  #    render :file => "#{RAILS_ROOT}/public/403.html", :status => 403
  #   # redirect_to new_user_session_path
  # end


  def index
    @credits = current_user.credits
    @debts = current_user.debts
    @contacts = current_user.active_contacts
  end

  def closed
    @closed_credits = current_user.credits.closed
  end
  
  def show
    @credit = current_user.credits.find(params[:id])
    authorize! :read, @credit
  end
  
  def new
    authorize! :create, Credit
    h = { :till => Date.today + 7 }
    @credit = Credit.new( h )

    
    # TODO Ability
    if params[:partner_id]
      @credit.debtor = User.find(params[:partner_id])
    else
      @credit.build_debtor
    end
    
  end
  
  def create
    authorize! :create, Credit
    
    # params[:credit][:debtor_attributes].delete(:id) # И зачем formtastic его вставляет?
    
    # ЗАчем?
    #params[:credit][:debtor_attributes][:state] = 'nopass'
    
    @credit = current_user.credits.new(params[:credit])
    
    if @credit.save
      flash[:notice] = "Successfully created credit."
      redirect_to credits_url
    else
      flash[:error] = "Более тщательно заполние поля."
      render :action => 'new'
    end
  end

  def close
    @credit = current_user.credits.find(params[:id])
    authorize! :close, @credit
    @credit.close
    flash[:notice] = "Successfully updated credit."
    redirect_back @credit
  end
  
  def edit
    @credit = current_user.credits.find(params[:id])
    authorize! :edit, @credit
  end

  def update
    @credit = current_user.credits.find(params[:id])
    authorize! :edit, @credit
    if @credit.update_attributes(params[:credit])
      flash[:notice] = "Successfully updated credit."
      redirect_back @credit
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @credit = current_user.credits.find(params[:id])
    authorize! :destroy, @credit

    @credit.destroy
    flash[:notice] = "Successfully destroyed credit."
    redirect_to credits_url
  end

    def send_confirm_request
    @credit = current_user.credits.find(params[:id])
    authorize! :send_confirm, @credit
    @credit.send_confirm( true )
    flash[:notice] = "Вашему должнику (#{@credit.debtor}) повторно отправлено письмо о запросе подтверждения долга."
    redirect_to :back
  end

  def notify_debtor
    @credit = current_user.credits.find(params[:id])
    authorize! :read, @credit
    @credit.notify_debtor
    flash[:notice] = "Вашему должнику (#{@credit.debtor}) отправлено напопинание о возврате долга."
    redirect_to :back
  end

end
