class Room < ApplicationRecord
  enum status: { waiting: 0, playing: 1 }

  before_validation :generate_code, on: :create

  validates :code, presence: true, uniqueness: true

  private

  def generate_code
    return if code.present?

    self.code = loop do
      random = SecureRandom.alphanumeric(6).upcase
      break random unless Room.exists?(code: random)
    end
  end
end