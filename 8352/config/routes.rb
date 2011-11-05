ActionController::Routing::Routes.draw do |map|

  map.login  '/login',  :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.resource :user_session
  map.resources :password_resets
  map.resources :users

  map.resources :streets, :only => :show
  map.resources :premises, :only => :show

  map.resource :search, :only => [:show, :create]

  map.root :controller => "home"
  
  map.namespace :admin do |admin|
    admin.resources :company_groups
    admin.resources :branches, 
                    :collection => { :move => :post }, 
                    :member => { 
                      :attach_group => :post, :detach_group => :get, :move_left => :post, :move_right => :post,
                      :branch_left => :post, :branch_right => :post
                    }
  end

#   map.namespace :admin do |admin|
#     admin.resources :users
#     admin.resources :companies
#     admin.resources :categories
#     admin.resources :tags
    
#     admin.resources :telefon_renames
#     admin.resources :telefon_federals

#     admin.resources :sources, :member => { :run => :get } do |source|
#       source.resources :links
#       source.resources :results, :collection => { :export => :get, :move => :post }
#     end
#     admin.resources :jobs
#     admin.resources :storages


#     admin.connect '/', :controller => 'companies', :action => 'index'
#  end

#  map.logout    '/logout',    :controller => 'sessions',  :action => 'destroy'
#  map.login     '/login',     :controller => 'sessions',  :action => 'new'
#  map.register  '/register',  :controller => 'users',     :action => 'create'
#  map.signup    '/signup',    :controller => 'users',     :action => 'new'
#  map.resource  :user_session
#  map.resource  :account, :controller => "users"
#  map.resources :users
#  map.resources :users,       :collection => { :activate => :get }
  
  
  map.resources :companies, :has_many => :results# [:tags]
  map.resources :branches #,  :has_many => [:companies]
  map.resources :company_groups
  
  map.resources :tags
#  map.resources :tags,        :has_many => [:companies]
  

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
