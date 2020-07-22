Rails.application.routes.draw do
	root to: 'user#edit'
	resources :user, only: [:index, :edit]
	devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
	devise_scope :user do
		delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session_path
	end
end
