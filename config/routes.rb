Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      # User認証
      mount_devise_token_auth_for "User", at: :auth, controllers: {
        registrations: "api/v1/auth/registrations"
      }

      namespace :auth do
        resources :sessions, only: [:index]
      end

      # Packs
      resources :packs do
        # PackItems
        resources :items, controller: "pack_items" do
          collection do
            patch "update_checked"
          end
        end
      end

      # API接続テスト
      resources :hello, only: [:index]

    end
  end

end
