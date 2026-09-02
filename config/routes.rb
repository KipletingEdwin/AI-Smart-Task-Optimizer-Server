
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        post "signup", to: "registrations#create"
        post "login", to: "sessions#create"
        get "up" => "rails/health#show", as: :rails_health_check
      end

      resources :tasks
    end
  end
end


