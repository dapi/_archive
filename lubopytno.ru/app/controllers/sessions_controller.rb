# -*- coding: utf-8 -*-
class SessionsController < Clearance::SessionsController
  layout "lean"
  #link_to t(:login), new_session_url(:return_to => request.request_uri)
  before_filter :set_return_to, :only => :new
 
  def set_return_to
    session[:return_to] = params[:return_to] if params[:return_to]
  end
  
  def url_after_destroy
    # TODO Проверить если кидает на restricted area то кидать домой
    request.referer || '/'
  end
end
