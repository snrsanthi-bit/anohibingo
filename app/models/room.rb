class Room < ApplicationRecord
  has_many :multiplayer_games, dependent: :destroy
  
  enum status: { waiting: 0, playing: 1 }

  before_validation :generate_code, on: :create

  validates :code, presence: true, uniqueness: true

  def join!(session)
    result = false

    with_lock do
      if session[:room_token].present? &&
         [player1_token, player2_token].include?(session[:room_token])
        result = true
      

      elsif player1_token.blank?
        self.player1_token = SecureRandom.hex(10)
        session[:room_token] = player1_token
        save!
        result = true

      elsif player2_token.blank?
        self.player2_token = SecureRandom.hex(10)
        session[:room_token] = player2_token
        self.status = :playing
        save!

        multiplayer_games.create! if multiplayer_games.empty?
        result = true
      end
    end

    result
  end

  def to_param
    code
  end


  private

  def generate_code
    return if code.present?

    self.code = loop do
      random = SecureRandom.alphanumeric(6).upcase
      break random unless Room.exists?(code: random)
    end
  end
end