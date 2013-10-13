Crowdpowered::Application.routes.draw do
  devise_for :users

  resources :events do
    resources :orders do
      post '/add_user', action: :add_user
      get :execute
      get :cancel
    end
  end

  resources :comments, :only => [:create, :destroy]

  resources :users

  root 'static_pages#home'

  get '/about' => 'static_pages#about'
end
