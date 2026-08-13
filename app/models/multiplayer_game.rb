class MultiplayerGame < ApplicationRecord
  belongs_to :room

  serialize :player1_board
  serialize :player2_board
  serialize :declared_numbers

  before_create :init_state

  def board_for(player)
    player == "player1" ? player1_board : player2_board
  end

  def declare(number, by:)
    return if winner.present?
    return unless by == current_turn
    return unless valid_declaration?(number)

    self.declared_numbers ||= []
    self.declared_numbers << {
      "number" => number,
      "by" => by
    }

    check_winner
    switch_turn unless winner.present?
  end


  def valid_declaration?(number)
    return false unless (1..25).include?(number)
    return false if declared_numbers.any? { |d| d["number"] == number }
    true
  end

  def marks_for(player)
    board = board_for(player)

    declared_numbers
      .select { |d| d["by"] == player }
      .map { |d| d["number"] }
      .select { |n| board.flatten.include?(n) }
  end

  def obstacles_for(player)
    board = board_for(player)

    declared_numbers
      .reject { |d| d["by"] == player }
      .map { |d| d["number"] }
      .select { |n| board.flatten.include?(n) }
  end

  def check_winner
    if Board.bingo?(player1_board, marks_for("player1"))
      self.winner = "player1"
    elsif Board.bingo?(player2_board, marks_for("player2"))
      self.winner = "player2"
    elsif declared_numbers.size == 25
      self.winner = "draw"
    end
  end

  def switch_turn
    self.current_turn =
      current_turn == "player1" ? "player2" : "player1"
  end

  private

  def init_state
    self.player1_board ||= Board.generate
    self.player2_board ||= Board.generate
    self.declared_numbers ||= []
    self.current_turn ||= ["player1", "player2"].sample
  end
end
