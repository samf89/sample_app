Rails.application.routes.draw do

  scope controller: :static_pages do
    get 'help' => :help
    get 'about' => :about
    get 'contact' => :contact
  end

  root 'static_pages#home'

  resources :users
  get 'signup' => 'users#new'

end
