class WelcomeController < ApplicationController
   
  def index
    redirect_to credits_url if user_signed_in?
    @credit = Credit.new
  end

end
