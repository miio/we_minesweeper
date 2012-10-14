class TopsController < ApplicationController
  respond_to :html, :json
  def index
    @rooms = Room.order("id desc").page params[:page]
    @room = Room.new level: :easy
  end
end
