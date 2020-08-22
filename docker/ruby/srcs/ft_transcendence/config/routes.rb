Rails.application.routes.draw do
	root to: 'user#index'
	resources :user
	resources :rooms do
		get 'join', on: :collection
		get 'password', on: :member
		post 'passwordset', on: :member
		resources :mutes, controller: 'room/mutes'
		resources :bans, controller: 'room/bans'
		resources :members, only: [:index, :new, :destroy]
		resources :admins, only: [:index, :new, :destroy]
	end

	resources :room_messages

	namespace :api do
		resources :room_users
		resources :room_settings, only: [:show, :update, :destroy]
	end

	devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
	devise_scope :user do
		delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session_path
	end
end
