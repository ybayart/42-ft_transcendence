class PickTournamentWinnerJob < ApplicationJob
  queue_as :default

  def perform(tournament)
  	$unfinished = Game.where(tournament: tournament, status: "running")
  	while $unfinished.length > 0
  		sleep(60)
  		$unfinished.each do |g|
  			g.reload
  			if g.status == "finished"
  				$unfinished.delete(g)
  			end
  		end
  	end

  	$max_win = 0
  	$winner = nil
  	$users = User.where(tournament: tournament)
  	$users.each do |u|
	  	$wins = 0
  		$games = Game.where(player1: u, tournament: tournament).or(Game.where(player2: u, tournament: tournament))
  		$games.each do |g|
  			if g.winner == u
  				$wins += 1
  			end
  		end
  		if $wins > $max_win
  			$max_win = $wins
  			$winner = u
  		end
  	end
  	tournament.winner = $winner
  	tournament.status = "finished"
  	tournament.save
  end
end
