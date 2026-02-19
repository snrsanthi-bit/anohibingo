class Board
  def self.generate
    (1..25).to_a.shuffle.each_slice(5).to_a
  end
end