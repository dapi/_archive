class HomeController < ApplicationController
  def index
    
    if current_user
      redirect_to profile_path
    else
      redirect_to new_user_path
    end

#    @user = User.new
  end
end
