# -*- coding: utf-8 -*-

module NotifierHelper
  
  # Ссылочка для удаленного захода на сайт и редиректа на go_path
  # @recipient устанавливается в Notifier
  
  def auth_link_to( text, go_path = root_path, user = @recipient )
    link_to text, users_token_auth_url( :auth_token => user.authentication_token, :go => go_path )
  end


end
