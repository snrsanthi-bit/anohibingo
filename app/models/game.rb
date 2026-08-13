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
    #Rails.logger.debug "DECLARE CALLED #{number}"
    #Rails.logger.debug "CURRENT TURN #{current_turn}"
    return if winner
    return unless valid_declaration?(number)

    session[:declared_numbers] << {
      "number" => number,
      "by" => current_turn
  }  

    check_winner
    switch_turn unless winner
    cpu_declare if current_turn == "opponent" && !winner
  end

  def player_marks
    marks_for(player_board, "player")
  end

  def opponent_marks
    marks_for(opponent_board, "opponent")
  end

  def declared_numbers_list
    declared_numbers.map { |d| d["number"] }
  end

  def player_obstacles
    obstacles_for(player_board, "player")
  end

  def opponent_obstacles
    obstacles_for(opponent_board, "opponent")
  end


  private

  def init_state
    session[:player_board]   ||= Board.generate
    session[:opponent_board] ||= Board.generate
    session[:declared_numbers] ||= []
    session[:current_turn] ||= "player"
  end

  def valid_declaration?(number)
    #Rails.logger.debug "VALID CHECK START"
    #Rails.logger.debug "DECLARED NUMBERS: #{declared_numbers.inspect}"

    return false unless (1..25).include?(number)
    return false if declared_numbers.any? { |d| d["number"] == number }
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

  def marks_for(board, owner)
    declared_numbers
      .select { |d| d["by"] == owner }
      .map { |d| d["number"] }
      .select { |n| board.flatten.include?(n) }
  end
  def obstacles_for(board, owner)
    declared_numbers
      .reject { |d| d["by"] == owner }
      .map { |d| d["number"] }
      .select { |n| board.flatten.include?(n) }
  end

  def cpu_declare
    available = (1..25).to_a - declared_numbers.map { |d| d["number"] }
    return if available.empty?

    cpu_board = opponent_board
    cpu_marks = opponent_marks

    winning_move = available.find do |n|
      Board.bingo?(cpu_board, cpu_marks + [n])
    end
    return declare(winning_move) if winning_move

    cpu_numbers = cpu_board.flatten
    meaningful = available.select { |n| cpu_numbers.include?(n) }
    
    move = meaningful.sample || available.sample

    declare(move)
  end
end