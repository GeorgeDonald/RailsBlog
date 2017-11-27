Rails.application.routes.draw do
  resources :users, only: [:create]
  resources :blogs, only: [:create]
  resources :comments, only: [:create]

  get '/', to: 'blogs#show'
  get '/signin', to: 'blogs#signin'
  get '/signup', to: 'blogs#signup'
  get '/logout', to: 'blogs#logout'
  get '/edit', to: 'blogs#edit'
  get '/write', to: 'blogs#write'
  get '/blogs/:id', to: 'blogs#editblog'
  get '/comments/:id', to: 'blogs#showcomment'

  patch '/users', to: 'users#create'
  patch '/blogs', to: 'blogs#create'
  delete '/blogs/:id', to: 'blogs#delete'
  patch '/blogs/:id', to: 'blogs#editblog'
  post '/comments/:id', to: 'blogs#comment'

  post '/comments', to: 'comments#create'
  patch '/comments', to: 'comments#create'
  delete '/comments/:id', to: 'comments#delete'
  patch '/comments/:id', to: 'blogs#editcomment'

  post '/blogs/next', to: 'blogs#nextpage'
  post '/blogs/prev', to: 'blogs#prevpage'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
