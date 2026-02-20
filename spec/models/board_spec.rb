require 'rails_helper'

RSpec.describe Board, type: :model do
  describe '.bingo?' do
    let(:board) do
      [
        [1, 2, 3, 4, 5],
        [6, 7, 8, 9, 10],
        [11, 12, 13, 14, 15],
        [16, 17, 18, 19, 20],
        [21, 22, 23, 24, 25]
      ]
    end

    context '横が揃った場合' do
      let(:marks) { [1, 2, 3, 4, 5] }

      it 'trueを返す' do
        expect(Board.bingo?(board, marks)).to be true
      end
    end

    context '縦が揃った場合' do
      let(:marks) { [1, 6, 11, 16, 21] }

      it 'trueを返す' do
        expect(Board.bingo?(board, marks)).to be true
      end
    end

    context '斜めが揃った場合' do
      let(:marks) { [1, 7, 13, 19, 25] }

      it 'trueを返す' do
        expect(Board.bingo?(board, marks)).to be true
      end
    end

    context '揃っていない場合' do
      let(:marks) { [1, 2, 3] }

      it 'falseを返す' do
        expect(Board.bingo?(board, marks)).to be false
      end
    end
  end
end