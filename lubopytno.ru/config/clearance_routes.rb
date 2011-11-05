ActionController::Routing::Routes.draw do |map|
  map.resources :passwords,
    :only       => [:new, :create]

  map.resource  :session,
    :only       => [:new, :create, :destroy]

  map.resources :users do |users|
    users.resource :password,
      :only       => [:create, :edit, :update]

    users.resource :confirmation,
      :only       => [:new, :create]
  end

  map.sign_up  'sign_up',
    :controller => 'users',
    :action     => 'new'
  map.sign_in  'sign_in',
    :controller => 'sessions',
    :action     => 'new'
  map.sign_out 'sign_out',
    :controller => 'sessions',
    :action     => 'destroy',
    :method     => :delete
end
