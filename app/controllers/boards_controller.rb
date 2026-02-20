class BoardsController < ApplicationController
  def show
    @game = Game.new(session)
  end

  def mark
    game = Game.new(session)
    game.declare(params[:number].to_i)
    redirect_to root_path
  end

  def reset
    session.clear
    redirect_to root_path
  end
end