class CheckTournamentGameJob < ApplicationJob
  queue_as :default

  def perform(tournament, game)
    $tournamentLogic = TournamentLogic.search(tournament.id)
    if game.status == "waiting"
  		game.status = "finished"	
    	if $gameLogic.player_ready[0] == false && $gameLogic.player_ready[1]
    		game.winner = game.player2
    	elsif $gameLogic.player_ready[1] == false && $gameLogic.player_ready[0]
    		game.winner = game.player1
    	end
    	game.save
    end
    if game.status == "finished"
      for i in 0...$tournamentLogic.players.count
        if game.winner == $tournamentLogic.players[i]
          $tournamentLogic.add_win(i)
        end
      end
    end
  end
end
