Rails.application.routes.draw do
  match '*path', via: [:options], to:  lambda {|_| [204, {'Access-Control-Allow-Headers' => "Origin, Content-Type, Accept, Authorization, Token", 'Access-Control-Allow-Origin' => "*", 'Content-Type' => 'text/plain'}, []]}
  post 'auth/token' => 'auth#token'
  resources :users, only: [:create]
  resources :questions do
    resources :revisions, only: [:create]
  end
end
