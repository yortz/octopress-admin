OctopressAdmin::Application.routes.draw do
  root to: "posts#index"
  resources :posts do
    get 'generate_site', :on => :collection
  end  

  # get 'signup', to: 'users#new', as: 'signup' #uncomment to enable sign up functionality
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :users
  resources :sessions
end
