class CheckTournamentGameJob < ApplicationJob
  queue_as :default

  def perform(game)
    $gameLogic = GameLogic.create(game.id)
    if game.status == "waiting"
		game.status = "finished"	
    	if $gameLogic.player_ready[0] == false && $gameLogic.player_ready[1]
    		game.winner = game.player2
    		game.save
    	elsif $gameLogic.player_ready[1] == false && $gameLogic.player_ready[0]
    		game.winner = game.player1
    		game.save
    	end
    end
  end
end
