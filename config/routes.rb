Rails.application.routes.draw do
  root 'products#index'
  #get '/auto' => 'products#automatic'
  devise_for :users
  post '/purchase' => 'orders#purchase_status'
  get "refund/:id", to: "orders#refund"
  resources :orders, only: [:index,:show] 
  resources :products
end
