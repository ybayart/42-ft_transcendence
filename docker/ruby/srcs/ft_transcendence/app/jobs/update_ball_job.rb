class UpdateBallJob < ApplicationJob
  queue_as :default

  def perform(game)
  	@gameLogic = GameLogic.create(game)
    while (@gameLogic)
    	@gameLogic.updateBallPos
	  	@gameLogic = GameLogic.create(game)
	  	puts "*******************************"
    	sleep(0.5)
    end
  end
end
