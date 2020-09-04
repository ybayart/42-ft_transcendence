class CreateTournamentGamesJob < ApplicationJob
  queue_as :default

  def perform(tournament)
    tournament.reload

    $players = tournament.users
    if ($players.length < 2)
      tournament.delete
      return
    end

    if $players.length % 2 == 1
      $players.push(nil)
    end

    $rounds_nb = $players.length - 1
    $half = $players.length / 2;
    $time = Time.now

    $playersIndex = [];
    $players.each_with_index do |p, i|
      $playersIndex.push(i + 1)
    end
    $playersIndex.slice(1..-1)
    
    for i in 0...$rounds_nb
      $time += i * 600
      $newPlayerIndex = [0].concat($playersIndex)
      $firstHalf = $newPlayerIndex.slice(0...$half);
      $secondHalf = $newPlayerIndex.slice($half...$players.length);
      for i in 0...$firstHalf.length
        $p1 = $players[$firstHalf[i]]
        $p2 = $players[$secondHalf[i]]
        if $p1 != nil && $p2 != nil
          $game = Game.create(player1: $p1, player2: $p2, status: "waiting", mode: "tournament", tournament: tournament, start_time: $time) 
          CheckTournamentGameJob.set(wait_until: $game.start_time + 300).perform_later($game)
        end
        $playersIndex.push($playersIndex.shift())
      end
    end
  end
end