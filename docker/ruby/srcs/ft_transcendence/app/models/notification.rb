class Notification < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :user, inverse_of: :notifications
  after_create_commit { NotificationsChannel.broadcast_to(self.user, title: self.title, href: notification_path(self.id)) }
end
