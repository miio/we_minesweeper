class RoomsController < ApplicationController
  respond_to :html, :json

  def show
    @room = Room.find(params[:id])
    @panels = @room.get_structure
  end

  def create
    @room = Room.new level: :easy
    @room.save
    respond_with(@room)
  end
end
