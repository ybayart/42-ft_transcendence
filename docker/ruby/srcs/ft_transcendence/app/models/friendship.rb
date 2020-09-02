class Friendship < ActiveRecord::Base
	belongs_to :friend_a, class_name: :User, required: true
	belongs_to :friend_b, class_name: :User, required: true
end
