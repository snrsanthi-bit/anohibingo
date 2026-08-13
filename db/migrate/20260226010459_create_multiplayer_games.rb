class CreateMultiplayerGames < ActiveRecord::Migration[7.0]
  def change
    create_table :multiplayer_games do |t|
      t.references :room, null: false, foreign_key: true

      t.text :player1_board
      t.text :player2_board
      t.text :declared_numbers

      t.string :current_turn
      t.string :winner

      t.timestamps
    end
  end
end