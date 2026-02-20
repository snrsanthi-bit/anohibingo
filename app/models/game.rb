class Game
  attr_reader :session

  def initialize(session)
    @session = session
    init_state
  end

  def player_board
    session[:player_board]
  end

  def opponent_board
    session[:opponent_board]
  end

  def declared_numbers
    session[:declared_numbers]
  end

  def current_turn
    session[:current_turn]
  end

  def winner
    session[:winner]
  end

  def declare(number)
    return if winner
    return unless valid_declaration?(number)

    session[:declared_numbers] << number

    check_winner
    switch_turn unless winner
  end

  def player_marks
    marks_for(player_board)
  end

  def opponent_marks
    marks_for(opponent_board)
  end

  private

  def init_state
    session[:player_board]   ||= Board.generate
    session[:opponent_board] ||= Board.generate
    session[:declared_numbers] ||= []
    session[:current_turn] ||= "player"
  end

  def valid_declaration?(number)
    return false unless (1..25).include?(number)
    return false if declared_numbers.include?(number)
    true
  end

  def check_winner
    if Board.bingo?(player_board, player_marks)
      session[:winner] = "player"
    elsif Board.bingo?(opponent_board, opponent_marks)
      session[:winner] = "opponent"
    elsif declared_numbers.size == 25
      session[:winner] = "draw"
    end
  end

  def switch_turn
    session[:current_turn] =
      current_turn == "player" ? "opponent" : "player"
  end

  def marks_for(board)
    declared_numbers.select { |n| board.flatten.include?(n) }
  end
end