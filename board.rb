require 'byebug'
require_relative 'piece.rb'

class Board

  def self.blank_grid
    Array.new(8) {Array.new(8)}
  end

  def initialize(rows = self.class.blank_grid)
    @rows = rows
  end

  def [](pos)
    row,col = pos[0],pos[1]
    @rows[row][col]
  end

  def []=(pos, piece)
    row,col = pos[0],pos[1]
    @rows[row][col] = piece
  end

  def display
    @rows.each do |row|
      p row
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  piece1 = Piece.new(board,[4,4],:W)
  piece2 = Piece.new(board,[3,3],:B)

  board[[4,4]] = piece1
  board[[3,3]] = piece2

  board.display
  piece2.perform_slide([4,2])
  puts "///////////////////"
  board.display

end
