class AddRematchFlagsToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :player1_rematch, :boolean, null: false, default: false
    add_column :rooms, :player2_rematch, :boolean, null: false, default: false
  end
end
