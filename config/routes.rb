Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth'
    namespace :v1 do
      resources :animals, only: %i[index create update destroy]
      resources :adoptions, only: %i[index show]
    end
  end
end
