Rails.application.routes.draw do

  scope controller: :static_pages do
    get 'home' => :home
    get 'help' => :help
    get 'about' => :about
  end

  root 'static_pages#home'

end
