Rails.application.routes.draw do

  # Home
  root 'home#show'
  get '/' => 'home#show'
  get 'home/show' => 'home#show'
  get 'home' => 'home#show'
  post 'home/signup'

  # Person
  get 'person/index'
  get 'person/edit'
  post 'person/update'
  get 'person/dashboard'
  get 'person/login'
  post 'person/authenticate'
  match  'person/forgot_password', via: [:get, :post]
  get 'person/reset_password'
  get 'person/change_password'
  post 'person/update_password'
  get 'person/logout'

  # Company
  get 'company/index'
  get 'company/new'
  post 'company/create'
  get 'company/show'
  get 'company/edit'
  post 'company/update'
  post 'company/destroy'

  # Location
  get 'location/index'
  get 'location/new'
  post 'location/create'
  get 'location/show'
  get 'location/edit'
  post 'location/update'
  post 'location/destroy'

  # Service
  get 'service/index'
  post 'service/create'
  post 'service/destroy'

  # Category
  get 'category/index'
  post 'category/create'
  post 'category/destroy'

end
