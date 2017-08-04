Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :pointers

  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  root :to => "home#index"

  get 'map' => 'home#map', :as => 'map'
  get 'list' => 'pointers#list', :as => 'list'
  get '/dynamic_content' => 'pointers#dynamic_content'
  get '/search' => 'home#search'

  get '/parse' => 'pointers#parse', :as => 'parse'
  get 'home/full_desc' => 'home#full_desc'
  get '/my_places' => 'home#my_places'
  get '/get_direction_info' => 'home#get_direction_info'
  get 'show_pointer_on_map/:id' => 'pointers#show_pointer_on_map', :as => 'show_pointer_on_map'
  get 'create_visit/:id' => 'desires#create_visit'
  get 'set_visited/:id' => 'desires#set_visited'
  get 'options' => 'home#options'

  post 'import_ratings' => 'pointers#import_ratings', defaults: {format: :json}
end
