Rails.application.routes.draw do

  get 'signup' => 'users#new'

  scope controller: :static_pages do
    get 'help' => :help
    get 'about' => :about
    get 'contact' => :contact
  end

  root 'static_pages#home'

end
