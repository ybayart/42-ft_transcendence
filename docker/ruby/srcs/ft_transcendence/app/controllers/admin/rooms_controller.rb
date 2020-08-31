class Admin::RoomsController < ApplicationController
  before_action :set_admin_room, only: [:show, :edit, :update, :destroy]

  # GET /admin/rooms
  # GET /admin/rooms.json
  def index
    @admin_rooms = Admin::Room.all
  end

  # GET /admin/rooms/1
  # GET /admin/rooms/1.json
  def show
  end

  # GET /admin/rooms/new
  def new
    @admin_room = Admin::Room.new
  end

  # GET /admin/rooms/1/edit
  def edit
  end

  # POST /admin/rooms
  # POST /admin/rooms.json
  def create
    @admin_room = Admin::Room.new(admin_room_params)

    respond_to do |format|
      if @admin_room.save
        format.html { redirect_to @admin_room, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @admin_room }
      else
        format.html { render :new }
        format.json { render json: @admin_room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/rooms/1
  # PATCH/PUT /admin/rooms/1.json
  def update
    respond_to do |format|
      if @admin_room.update(admin_room_params)
        format.html { redirect_to @admin_room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_room }
      else
        format.html { render :edit }
        format.json { render json: @admin_room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/rooms/1
  # DELETE /admin/rooms/1.json
  def destroy
    @admin_room.destroy
    respond_to do |format|
      format.html { redirect_to admin_rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_room
      @admin_room = Admin::Room.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_room_params
      params.fetch(:admin_room, {})
    end
end
