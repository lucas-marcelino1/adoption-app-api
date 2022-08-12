Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'home' => 'home#home'
    end
  end
end
