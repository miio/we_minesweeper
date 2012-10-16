class AddAuthorToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :author_id, :integer
    add_index :rooms, :author_id
  end
end
