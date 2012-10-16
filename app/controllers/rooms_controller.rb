class RoomsController < ApplicationController
  respond_to :html, :json

  def show
    @room = Room.find(params[:id])
    @panels = @room.get_structure
    @room_ranking = @room.get_room_ranking
  end

  def create
    @room = Room.new level: :easy
    @room.author = current_user
    @room.save
    respond_with(@room)
  end
end
