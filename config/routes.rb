

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        post "signup", to: "registrations#create"
        post "login", to: "sessions#create"
      end

      resources :tasks do
        collection do
          post :create_from_ai
        end
      end

      resources :subtasks, only: [] do
        member do
          patch :toggle
        end
      end
    end
  end
end