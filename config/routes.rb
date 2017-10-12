Rails.application.routes.draw do

  root 'pages#home'

  resources :lessons
  resources :paths

end
