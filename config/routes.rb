Rails.application.routes.draw do
  # API definition
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[show create update destroy index]
      resources :tokens, only: %i[create]
      resources :products, only: %i[show index]
    end
  end
end
