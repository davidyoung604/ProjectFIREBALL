Rails.application.routes.draw do
  # Priority is based on order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  root 'stats#index'

  # setting both the aliased and non-aliased so nothing breaks if on/off
  get '/user_files/untagged' => 'user_files#untagged'
  get '/files/untagged' => 'user_files#untagged'
  get '/stream/:id' => 'user_files#stream', as: 'stream'

  resources :directories
  resources :user_files, path: 'files'
  resources :tags
  resources :categories
  resources :users
  resources :stats

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

  get '/search' => 'searches#index'

  match '*path' => redirect('/'), via: :all
end
