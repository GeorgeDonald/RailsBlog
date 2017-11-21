Rails.application.routes.draw do
  resources :users, only: [:create]
  get '/', to: 'blogs#show'
  get '/signin', to: 'blogs#signin'
  get '/signup', to: 'blogs#signup'
  post '/', to: 'users#cancel'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
