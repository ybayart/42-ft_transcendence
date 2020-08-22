Rails.application.routes.draw do
	root to: 'user#index'
	resources :user
	resources :game
	resources :rooms do
		get 'join', on: :collection
	end

	get '/play', to: 'game#play'
	get '/test', to: 'game#test'

	resources :room_messages

	devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
	devise_scope :user do
		delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session_path
	end
end
