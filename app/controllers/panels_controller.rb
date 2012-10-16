class PanelsController < ApplicationController
  def update
    @room_panel = Panel.find(params[:id])
    @room_panel.click current_user
    redirect_to @room_panel.room
  end
end
