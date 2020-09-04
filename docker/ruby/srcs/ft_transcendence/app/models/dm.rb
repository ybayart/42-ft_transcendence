class Dm < ApplicationRecord
	belongs_to :user1, class_name: :User, required: true
	belongs_to :user2, class_name: :User, required: true
	has_many :dm_messages, dependent: :destroy, inverse_of: :dm

	validate :check_exists

	def check_exists
		dm = Dm.where("(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)", self.user1, self.user2, self.user2, self.user1)
		if dm.exists? and dm.take.id != self.id
			errors.add(:user2_id, "must be unique")
		end
	end
end
