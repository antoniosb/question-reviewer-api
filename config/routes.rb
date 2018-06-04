Rails.application.routes.draw do
  post 'auth/token' => 'auth#token'
  resources :users, only: [:create]
  resources :questions do
    resources :revisions, only: [:create]
  end
end
