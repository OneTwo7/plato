Rails.application.routes.draw do

  root 'pages#home'

  resources :paths do
    resources :lessons
  end

end
