class BoardsController < ApplicationController
  def show
    session[:board] ||= Board.generate
    session[:marks] ||= { "player" => [], "opponent" => [] }

    @board = session[:board]
    @marks = session[:marks]
    @winner = session[:winner]
  end

  def mark
    return if session[:winner]

    session[:marks] ||= { "player" => [], "opponent" => [] }

    number = params[:number].to_i
    type = params[:type] || "player"

    return unless session[:board].flatten.include?(number)
    return unless ["player", "opponent"].include?(type)
    return if session[:marks]["player"].include?(number) ||
              session[:marks]["opponent"].include?(number)

    session[:marks][type] << number

    if Board.bingo?(session[:board], session[:marks][type])
      session[:winner] = type
    else
      total_marks =
        session[:marks]["player"].size +
        session[:marks]["opponent"].size

      session[:winner] = "draw" if total_marks == 25
    end

    redirect_to root_path
  end


  def reset
    session.delete(:board)
    session.delete(:marks)
    session.delete(:winner)
    redirect_to root_path
  end
end
