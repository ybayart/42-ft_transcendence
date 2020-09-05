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
  	@tournament = Tournament.find_by(id: id);
  	@players = Array.new();
  	@players_points = Array.new();
  end

  def players
    @players
  end

  def players_points
    @players_points
  end

  def tournament
    @tournament
  end

  def set_players(players)
    @players = players    
  end

  def add_win(index)
    @players_points[i] += 1
  end
end