class PanelsController < ApplicationController
  def update
    @room_panel = Panel.find(params[:id])
    @room_panel.click
    redirect_to @room_panel.room
  end
end
