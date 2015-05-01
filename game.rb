require_relative "board.rb"
require_relative "piece.rb"

class Game

  def initialize(board)
    @board = board
  end

  def winner
    pieces = @board.flatten.compact

    if pieces.none? {|piece| piece.color == :white}
      :black
    elsif pieces.none? {|piece| piece.color == :black}
      :white
    end
    nil
  end

  def won?
    if winner == nil?
      return false
    else
      return true
    end
  end

  def make_move
    puts "Select a piece"
    current_position = gets.chomp
    puts "Where would you like to move?"
    move_sequence = gets.chomp

    @board[current_position].perform_moves(move_sequence)
  end

  def run
    until won?


  end



end
