Rtb::Application.routes.draw do


  # resources :authentications
  # match '/auth/:provider/callback' => 'authentications#create'
  
  devise_for :users, :controllers => {
    :registrations => "registrations",
    :passwords => "passwords",
    :sessions => "sessions",
    :omniauth_callbacks => "users/omniauth_callbacks"
  }
  
  root :to => "welcome#index"

  match 'users/token_auth' => 'users#token_auth'
  match 'users/unsubscribe' => 'users#unsubscribe'

  resources :contacts

  resources :debts do
    member do
      get 'close'
      get 'confirm'
      post 'confirm'
    end
    collection do
      get 'closed'
    end
  end

  resources :credits do
    member do
      get 'close'
      get 'confirm'
      post 'confirm'
      get 'send_confirm_request'
      get 'notify_debtor'
    end
    
    collection do
      get 'closed'
    end
  end
  
end
