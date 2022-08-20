Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth'
    namespace :v1 do
      resources :animals, only: %i[index create update destroy]
      resources :adoptions, only: %i[index create show update destroy] do
        post 'adopt', on: :member
      end
    end
  end
end
