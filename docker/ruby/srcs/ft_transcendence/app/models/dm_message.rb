class DmMessage < ApplicationRecord
	belongs_to :user
	belongs_to :dm, inverse_of: :dm_messages

	validates	:message, presence: true
end
