module ApplicationHelper
	def create_alert(message)
		raw("<div name='toast-alert' class='toast' role='alert' aria-live='assertive' aria-atomic='true' data-delay='10000'>
			<div class='toast-body'>
				" + message + "
			</div>
		</div>")
	end

end
