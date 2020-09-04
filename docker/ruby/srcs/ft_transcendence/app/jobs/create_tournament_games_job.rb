class CreateTournamentGamesJob < ApplicationJob
  queue_as :default

  def perform(tournament)
    tournament.reload

    $count = tournament.users.count
    if ($count < 2)
      tournament.delete
      return
    end

    $players = Array.new($count, nil)
    if $count % 2 == 1
      $players.push(nil)
    end

    for i in 0...$count
      $players[i] = tournament.users[i]
    end

    $rounds_nb = $players.length - 1
    $half = $players.length / 2;
    $time = Time.now

    $playersIndex = [];
    for i in 0...$players.length
      $playersIndex.push(i)
    end
    $playersIndex.shift
    
    for i in 0...$rounds_nb
      if i != 0
        $time += 600
      end
      $newPlayerIndex = [0].concat($playersIndex)
      $firstHalf = $newPlayerIndex.slice(0...$half);
      $secondHalf = $newPlayerIndex.slice($half...$players.length).reverse();
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