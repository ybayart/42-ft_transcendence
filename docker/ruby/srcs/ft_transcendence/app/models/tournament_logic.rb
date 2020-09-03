class TournamentLogic
  include ActiveModel::Model

  @@tournaments = Hash.new

  def self.create(id)
	if !@@tournaments[:id]
	  @@tournaments[:id] ||= TournamentLogic.new(id)
	end
	@@tournaments[:id]
  end

  def self.delete(id)
	if @@tournaments && @@tournaments[:id]
      @@tournaments[:id] = nil
	  @@tournaments.delete(id)
	end
  end

  def self.search(id)
	$tournament = nil
	if @@tournaments && @@tournaments[:id]
	  $tournament = @@tournaments[:id]
	end
	$tournament
  end

  def initialize(id)
  	@players = Array.new();
  	@tournament = Tournament.find_by(id: id);
  	@games = Array.new();
  	@players_points = Array.new();
  end

  def players
	@players
  end

  def tournament
	@tournament
  end

  def games
	@games
  end

  def create_games

  end

end