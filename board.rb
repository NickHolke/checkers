require 'byebug'

class Board
  attr_reader :rows

  def self.blank_grid
    Array.new(8) {Array.new(8)}
  end

  def initialize(rows = self.class.blank_grid, pop = true)
    @rows = rows
    if pop == true
      populate
    end
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
      row.each do |tile|
        if tile.nil?
          print "_"
        elsif tile.color == :white
          print "W"
        elsif tile.color == :black
          print "B"
        elsif tile.color == :black && tile.king == true
          print "BK"
        elsif tile.color == :white && tile.king == true
          print "WK"
        end
      end
      puts "\n"
    end
  end

  def deep_dup
    dup_board = Board.new(rows = self.class.blank_grid, pop=false)

    pieces = @rows.flatten.compact

    pieces.each do |piece|
      dup_board[piece.position] = Piece.new(dup_board, piece.position, piece.color, piece.king)
    end
    dup_board
  end

  def populate
    @rows.each_with_index do |el, row|
      el.each_index do |col|
        if row == 0 || row == 2
          if col % 2 != 0
            self[[row, col]] = Piece.new(self, [row,col], :black)
          end
        end

        if row == 6
          if col % 2 != 0
            self[[row, col]] = Piece.new(self, [row,col], :white)
          end
        end

        if row == 5 || row == 7
          if col % 2 == 0
            self[[row, col]] = Piece.new(self, [row,col], :white)
          end
        end

        if row == 1
          if col % 2 == 0
            self[[row, col]] = Piece.new(self, [row,col], :black)
          end
        end
      end
    end
  end
end
