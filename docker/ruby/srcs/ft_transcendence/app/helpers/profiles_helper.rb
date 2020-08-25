module ProfilesHelper
	def set_bold(data, player, winner)
		if player == winner
			raw("<b>#{data}</b>")
		else
			data
		end
	end
end
