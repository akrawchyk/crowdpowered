Crowdpowered::Application.routes.draw do
  devise_for :users

  resources :events do
    resources :users
    resources :supplies
    resources :orders do
      get :execute
      get :cancel
    end
  end

  resources :comments, :only => [:create, :destroy]

  resources :users

  root 'static_pages#home'

  get '/about' => 'static_pages#about'
end
