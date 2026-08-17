class RoomsController < ApplicationController
  def create
    room = Room.create!
    room.join!(session)
    redirect_to room_path(room), status: :see_other
  end

  def show
    @room = Room.find_by!(code: params[:code])

    # 勝者がいる場合は結果表示
    if @room.multiplayer_games.last&.winner.present?
      @game = @room.multiplayer_games.last
      return
    end

    if @room.playing?
      redirect_to multiplayer_game_path(@room.multiplayer_games.last)
      return
    end

    @game = @room.multiplayer_games.last
  end

  def join
    @room = Room.find_by!(code: params[:code])

    joined = @room.join!(session)

    unless joined
      redirect_to root_path, alert: "このルームは満員です"
      return
    end

    if @room.playing?
      redirect_to multiplayer_game_path(@room.multiplayer_games.last)
    else
      redirect_to room_path(@room)
    end
  end

  def rematch_status
    room = Room.find(params[:id])

    render json: {
      player1_rematch: room.player1_rematch,
      player2_rematch: room.player2_rematch,
      game_started: room.playing?,
      game_id: room.multiplayer_games.order(created_at: :desc).first&.id
    }
  end
end