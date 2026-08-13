class ApplicationController < ActionController::Base
  helper_method :current_player

  def current_player(room)
    token = session[:room_token]
    return nil if token.blank?

    if token == room.player1_token
      "player1"
    elsif token == room.player2_token
      "player2"
    end
  end
end