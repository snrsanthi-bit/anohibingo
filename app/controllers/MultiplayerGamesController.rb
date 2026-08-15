class MultiplayerGamesController < ApplicationController

  def show
    @game = MultiplayerGame.find(params[:id])
    @room = @game.room
    @player = current_player(@room)
  end
  
  def declare
    @game = MultiplayerGame.find(params[:id])
    player = current_player(@game.room)

    unless player
      redirect_to root_path, alert: "不正なアクセスです"
      return
    end

    @game.declare(params[:number].to_i, by: player)
    @game.save

    if @game.winner.present?
      redirect_to result_multiplayer_game_path(@game)
    else
      redirect_to room_path(@game.room)
    end
  end

  def result
    @game = MultiplayerGame.find(params[:id])
    @room = @game.room

    unless session[:room_token].present?
      @room.join!(session)
    end

    
    @player = current_player(@room)
  end

  def rematch
    old_game = MultiplayerGame.find(params[:id])
    room = old_game.room

      if room.player1_token == session[:room_token]
        room.update(player1_rematch: true)
      else room.player2_token == session[:room_token]
        room.update(player2_rematch: true)
      end

    if room.player1_rematch && room.player2_rematch?

      room.multiplayer_games.create!(
        player1_board: Board.generate,
        player2_board: Board.generate,
        declared_numbers: [],
        current_turn: ["player1", "player2"].sample,
        winner: nil
      )
    
      redirect_to room_path(room)
    end
  end
end