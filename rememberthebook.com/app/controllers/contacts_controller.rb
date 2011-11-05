class ContactsController < ApplicationController

  before_filter :authenticate_user! 

  def index
    @contacts = current_user.contacts
  end

  def show
    @contact = Contact.find(params[:id])
    @credits = current_user.contacts_credits @contact
    @debts = current_user.contacts_debts @contact
    @show_contact = false
  end

  
end
