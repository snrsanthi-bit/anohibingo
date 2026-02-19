class BoardsController < ApplicationController
  def show
    @board = Board.generate
  end
end
