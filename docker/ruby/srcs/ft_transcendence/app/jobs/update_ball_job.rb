class UpdateBallJob < ApplicationJob
  queue_as :default

  def perform(id)
  	@gameLogic = GameLogic.search(id)
    while (@gameLogic)
    	if (@gameLogic.state == "play")
	    	@gameLogic.updateBallPos
	    end
	  	@gameLogic = GameLogic.search(id)
    	sleep(1.0/50.0)
    end
  end
end
