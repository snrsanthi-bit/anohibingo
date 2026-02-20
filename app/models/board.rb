class Board
  def self.generate
    (1..25).to_a.shuffle.each_slice(5).to_a
  end
  def self.generate_lines(board)
    lines = []

  # 横
    lines += board

  # 縦
    lines += board.transpose

  # 斜め
    lines << (0..4).map { |i| board[i][i] }
    lines << (0..4).map { |i| board[i][4 - i] }

    lines
  end

  def self.bingo?(board, marks)
    generate_lines(board).any? do |line|
      line.all? { |n| marks.include?(n) }
    end
  end
end