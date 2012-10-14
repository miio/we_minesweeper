class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :level
      t.timestamps
    end
  end
end
