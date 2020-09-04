Rails.application.routes.draw do

  resources :dms
	root to: 'profile/friends#index'
	resources :profiles do
		get 'otp', on: :collection
		post 'otppost', on: :collection
		resources :friends, controller: 'profile/friends', only: [:index, :new, :create, :destroy]
		resources :mutes, controller: 'profile/mutes', only: [:index, :new, :create, :destroy]
	end
	resources :rooms do
		get 'join', on: :collection
		get 'password', on: :member
		post 'passwordset', on: :member
		resources :mutes, controller: 'room/mutes'
		resources :bans, controller: 'room/bans'
		resources :members, controller: 'room/members', only: [:index, :new, :create, :destroy]
		resources :admins, controller: 'room/admins', only: [:index, :new, :create, :destroy]
	end

	resources :room_messages, only: [:create]

	resources :dms, only: [:index, :new, :create, :show, :destroy]

	resources :dm_messages, only: [:create]

	resources :game, only: [:index, :show]
	get '/play', to: 'game#play'
	get '/test', to: 'game#test'
	get '/spectate/:id', to: 'game#spectate'

<<<<<<< HEAD
	resources :tournaments
	get '/register/:id', to: 'tournaments#register'


	resources :room_messages

=======
>>>>>>> 7b8069bc0080c196b6d727cf27f6113ec70df068
	resources :guilds do
		get 'invitations', on: :collection
		patch 'invitationspost/:id', as: 'invitationspost', to: 'guilds#invitationspost', on: :collection
		resources :invites, controller: 'guild/invites', only: [:index, :new, :create, :destroy]
		resources :members, controller: 'guild/members', only: [:index, :destroy]
		resources :officers, controller: 'guild/officers', only: [:index, :new, :create, :destroy]
	end

	resources :wars do
		resources :times, controller: 'war/times', only: [:index, :new, :create, :edit, :update, :destroy]
	end

	namespace :admin do
		resources :rooms, only: [:index, :show, :destroy]
		resources :guilds, only: [:index, :show]
		resources :moderators, only: [:index, :new, :create, :destroy]
	end

	namespace :api do
		resources :room_users
		resources :room_settings, only: [:show, :update, :destroy]
	end

	devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
	devise_scope :user do
		delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session_path
	end
end
