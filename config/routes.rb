Rails.application.routes.draw do

  root 'home#index'
  
  get 'home/index' => 'home#index'

  get 'home' => 'home#index'
  
  get '/' => 'home#index'

  get 'category/index' => 'category#index'

  post 'home/signup'
  
  get 'person/edit_profile'
  
  post 'person/save_profile'
  
  get 'person/dashboard'

  get 'person/login'
  
  post 'person/authenticate'
  
  match  'person/forgot_password', via: [:get, :post]
  
  get 'person/reset_password'
  
  get 'person/change_password'
  
  post 'person/update_password'
  
  get 'person/logout'

end
