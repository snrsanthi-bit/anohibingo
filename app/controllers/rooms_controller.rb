class RoomsController < ApplicationController
  def create
    room = Room.create!
    redirect_to room_path(room), status: :see_other
  end



  def show
    #Rails.logger.debug "SHOW ACTION HIT"
    @room = Room.find_by!(code: params[:code])

    # 勝者がいる場合は結果表示
    if @room.multiplayer_games.last&.winner.present?
      @game = @room.multiplayer_games.last
      return
    end
    Rails.logger.debug "JOIN HIT"
    joined = @room.join!(session)

    unless joined
      redirect_to root_path, alert: "このルームは満員です"
      return
    end

    if @room.playing?
      redirect_to multiplayer_game_path(@room.multiplayer_games.last)
      return
    end

    @game = @room.multiplayer_games.last
  end
end