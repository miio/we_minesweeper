class TopsController < ApplicationController
  respond_to :html, :json
  def index
    @rooms = Room.all
    @room = Room.new level: :easy
  end
end
