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

  def deep_dup
    dup_board = Board.new

    pieces = @rows.flatten.compact

    pieces.each do |piece|
      dup_board[piece.position] = Piece.new(dup_board, piece.position, piece.color, piece.king)
    end
    dup_board
  end

end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  piece1 = Piece.new(board, [1,3], :B, true)
  piece2 = Piece.new(board, [2,2], :W)
  piece3 = Piece.new(board, [4,2], :W)
  piece4 = Piece.new(board, [4,4], :W)

  board[[1,3]] = piece1
  board[[2,2]] = piece2
  board[[4,2]] = piece3
  board[[4,4]] = piece4

  board.display
  p "///////////////"

  piece1.perform_moves([[3,1],[5,3],[3,6]])
  board.display

end
