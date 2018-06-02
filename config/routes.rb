Rails.application.routes.draw do
  post 'auth/token' => 'user_token#create'
  resources :users, only: [:create]
  resources :questions do
    resources :revisions, only: [:create]
  end
end
