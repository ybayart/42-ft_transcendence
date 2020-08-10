Rails.application.routes.draw do
  resources :room_messages
  resources :rooms
	root to: 'user#index'
	resources :user
	resources :chat

	devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
	devise_scope :user do
		delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session_path
	end
end
