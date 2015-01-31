Rails.application.routes.draw do

  root 'static_pages#home'

  scope controller: :static_pages do
    get 'help'    => :help
    get 'about'   => :about
    get 'contact' => :contact
  end

  resources :users do
    member do
      get :following, :followers
    end
  end
  
  get 'signup' => 'users#new'

  scope controller: :sessions do
    get 'login'     => :new
    post 'login'    => :create
    delete 'logout' => :destroy
  end

  resources :account_activations, only: :edit
  resources :microposts, only: [:create, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :relationships, only: [:create, :destroy]

end
