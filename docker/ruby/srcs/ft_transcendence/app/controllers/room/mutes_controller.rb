class Room::MutesController < ApplicationController
  before_action :set_room
  before_action	:is_admin
  before_action :set_room_mute, only: [:show, :edit, :update, :destroy]

  # GET /room/mutes
  # GET /room/mutes.json
  def index
    @room_mutes = RoomMute.all
  end

  # GET /room/mutes/1
  # GET /room/mutes/1.json
  def show
  end

  # GET /room/mutes/new
  def new
    @room_mute = RoomMute.new
  end

  # GET /room/mutes/1/edit
  def edit
  end

  # POST /room/mutes
  # POST /room/mutes.json
  def create
    @room_mute = RoomMute.new(room_mute_params)
	@room_mute.room = @room
	@room_mute.by = current_user

    respond_to do |format|
      if @room_mute.save
        format.html { redirect_to room_mute_path(@room, @room_mute), notice: 'Mute was successfully created.' }
        format.json { render :show, status: :created, location: room_mute_path(@room, @room_mute) }
      else
        format.html { render :new }
        format.json { render json: @room_mute.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /room/mutes/1
  # PATCH/PUT /room/mutes/1.json
  def update
    respond_to do |format|
      if @room_mute.update(room_mute_params)
        format.html { redirect_to room_mute_path(@room, @room_mute), notice: 'Mute was successfully updated.' }
        format.json { render :show, status: :ok, location: room_mute_path(@room, @room_mute) }
      else
        format.html { render :edit }
        format.json { render json: @room_mute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /room/mutes/1
  # DELETE /room/mutes/1.json
  def destroy
    @room_mute.destroy
    respond_to do |format|
      format.html { redirect_to room_mutes_url, notice: 'Mute was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:room_id])
    end

	def is_admin
		redirect_to @room, :alert => "Missing permission" and return unless @room.admins.include?(current_user)
	end

    # Use callbacks to share common setup or constraints between actions.
    def set_room_mute
      @room_mute = @room.mutes.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def room_mute_params
      params.require(:room_mute).permit(:user_id, :end_at)
    end
end
