class Notification < ApplicationRecord
  belongs_to :user
  after_create_commit { NotificationsChannel.broadcast_to(self.user, body: self.message) }
end
