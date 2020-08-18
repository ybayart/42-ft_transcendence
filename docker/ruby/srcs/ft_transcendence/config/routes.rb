Rails.application.routes.draw do
	root to: 'user#index'
	resources :user
	resources :rooms do
		get 'join', on: :collection
	end

	resources :room_messages

	namespace :api do
		resources :room_users
	end

	devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
	devise_scope :user do
		delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session_path
	end
end
