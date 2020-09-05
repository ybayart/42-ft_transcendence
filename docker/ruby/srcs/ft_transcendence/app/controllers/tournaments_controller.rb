class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :register]

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.all
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
  end

  def register
    if @tournament.users.count + 1 <= @tournament.max_player
      current_user.tournaments.push(@tournament)
      current_user.save
      $notice = 'Registered to tournament.'
    else
      $notice = 'Tournament is full.'
    end
    respond_to do |format|
      format.html { redirect_to @tournament, notice: $notice }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tournament_params
      params.require(:tournament).permit(:mode, :max_player, :start_time, :points_award)
    end
end
