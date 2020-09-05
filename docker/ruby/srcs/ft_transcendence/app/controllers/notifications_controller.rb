class NotificationsController < ApplicationController
	before_action :set_notification, only: [:show]
	before_action :is_mine, only: [:show]

	# GET /notifications
	# GET /notifications.json
	def index
		@notifications = current_user.notifications
	end

	# GET /notifications/1
	# GET /notifications/1.json
	def show
	end

	private
		def set_notification
			begin
				@notification = Notification.find(params[:id])
			rescue
				redirect_to notifications_path, :alert => "Notification not found" and return
			end
		end

		def is_mine
			redirect_to notifications_path, :alert => "It's not you" and return unless @notification.user == current_user
		end
end
