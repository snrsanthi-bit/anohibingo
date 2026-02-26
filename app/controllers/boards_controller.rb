class BoardsController < ApplicationController
  def show
    @game = Game.new(session)
  end

  def mark
    game = Game.new(session)
    game.declare(params[:number].to_i)

     if game.winner
      redirect_to result_path
    else
      redirect_to solo_path
    end
  end

  def reset
    session.clear
    redirect_to solo_path
  end

  def result
    @game = Game.new(session)
  end
end