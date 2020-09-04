class War < ApplicationRecord
	include Rails.application.routes.url_helpers
	include ActionView::Helpers::UrlHelper
	belongs_to :guild1, class_name: :Guild, required: true
	belongs_to :guild2, class_name: :Guild, required: true
	belongs_to :winner, class_name: :Guild, required: false
	has_many :war_times, dependent: :destroy, inverse_of: :war

	validates :state,
			presence: true,
			inclusion: {
				in: ["waiting for war times", "declared", "aborted", "rejected", "pending", "active", "ended"],
				message: "%{value} is not a valid state"}

	validate :check_start_date, :on => :create
	validate :check_end_date

	after_save :notif

	def check_start_date
		errors.add(:start_at, "is in past") if self.start_at.past?
	end

	def check_end_date
		errors.add(:end_at, "is before start date") if self.end_at < self.start_at
	end

	def notif
		if self.state == "declared"
			self.guild2.officers.each do |user|
				Notification.create(user: user, title: "New war asking!", message: "Guild <b>#{link_to self.guild1.name, guild_path(self.guild1)}</b> asked you for a war, you can see details #{link_to 'here', war_path(self)}")
			end
		end
	end
end
