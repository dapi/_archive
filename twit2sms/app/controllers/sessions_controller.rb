# -*- coding: utf-8 -*-
class SessionsController < ApplicationController
  def new
    
    @user=User.find_by_phone(session[:phone])  if  session[:phone]

  end
  
  def create
    user = User.authenticate(params[:phone], params[:password])
    if user
      session[:user_id] = user.id
      flash[:notice] = "Logged in successfully."
      if session[:twitter]
        user.follow(session[:twitter])
        # TODO редирект куда надо, если не прошло
      end
      redirect_to root_url
    else
      @user=User.find_by_phone(session[:phone])  if  session[:phone]
      flash.now[:error] = "Invalid login or password."
      render :action => 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end
end
