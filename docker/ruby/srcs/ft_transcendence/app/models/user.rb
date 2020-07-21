class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable,
			:rememberable, :validatable,
			:omniauthable, omniauth_providers: [:marvin]

	def self.from_omniauth(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
			user.email = auth.info.email
			user.password = Devise.friendly_token[0,20]
			user.login = auth.info.nickname
			user.nickname = auth.info.nickname
			user.profile_pic = auth.info.image
		end
	end
end
