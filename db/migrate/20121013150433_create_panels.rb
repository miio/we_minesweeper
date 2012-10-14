class CreatePanels < ActiveRecord::Migration
  def change
    create_table :panels do |t|
      t.references :room
      t.integer :width
      t.integer :height
      t.integer :bomb_flag, default: 0
      t.boolean :is_open, default: false
      t.boolean :is_bomb, default: false
      t.timestamps
    end
  end
end
