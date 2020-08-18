require 'open-uri'
class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	has_one_attached	:profile_pic
	has_many :room_link_members
	has_many :rooms_member, :through => :room_link_members, :source => :room
	has_many :room_link_admins
	has_many :rooms_admin, :through => :room_link_admins, :source => :room
	has_many :rooms_owner, class_name: "Room", foreign_key: "owner_id", inverse_of: :owner
	has_many :send_bans, class_name: "RoomBan", foreign_key: "by_id", inverse_of: :by
	has_many :receive_bans, class_name: "RoomBan", foreign_key: "user_id", inverse_of: :user
	has_many :send_mutes, class_name: "RoomMute", foreign_key: "by_id", inverse_of: :by
	has_many :receive_mutes, class_name: "RoomMute", foreign_key: "user_id", inverse_of: :user
	has_many :friendship_ones, :class_name => 'Friendship', :foreign_key => :friend_b_id
	has_many :friend_a, through: :friendship_ones
	has_many :friendship_twos, :class_name => 'Friendship', :foreign_key => :friend_a_id
	has_many :friend_b, through: :friendship_twos

	def friends
		friend_a + friend_b
	end

	devise :database_authenticatable,
			:rememberable, :validatable,
			:omniauthable, omniauth_providers: [:marvin]

	def self.from_omniauth(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
			user.email = auth.info.email
			user.password = Devise.friendly_token[0,20]
			user.login = auth.info.nickname
			user.nickname = auth.info.nickname
			file = open(auth.info.image)
			user.profile_pic.attach(io: open(file), filename: File.basename(file))
		end
	end
end
