class AddPlayerTokensToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :player1_token, :string
    add_column :rooms, :player2_token, :string

    remove_column :rooms, :host_joined, :boolean
  end
end