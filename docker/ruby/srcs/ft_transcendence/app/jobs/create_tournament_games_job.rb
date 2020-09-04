class CreateTournamentGamesJob < ApplicationJob
  queue_as :default

  def perform(tournament)
    # Do something later
    tournament.reload
    tournament.users[0..-2].each_with_index do |p1, i|
    	tournament.users[i + 1..-1].each do |p2|
    		Game.create(player1: p1, player2: p2, status: "waiting", mode: "tournament", tournament: tournament)
    	end
    end
  end
end
