class UpdateBallJob < ApplicationJob
  queue_as :default

  def perform(id)
  	@gameLogic = GameLogic.search(id)
    while (@gameLogic)
    	@gameLogic.updateBallPos
	  	@gameLogic = GameLogic.search(id)
    	sleep(1.0/50.0)
    end
  end
end
