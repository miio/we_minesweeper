class AddIndexPanelsRoom < ActiveRecord::Migration
  def change
    add_index :panels, :room_id
  end
end
