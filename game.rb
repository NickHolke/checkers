require_relative "board.rb"
require_relative "piece.rb"
require "byebug"

class Game

  def initialize
    @board = Board.new
  end

  def winner
    pieces = @board.rows.flatten.compact

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
    current_position = gets.chomp.split(',').map(&:to_i)

    puts "Would you like to make multiple moves?(Y/N)"
    a = gets.chomp
    if a == "N"
      puts "Enter Move"

    move_sequence = gets.chomp.split(',').map(&:to_i)
    debugger
    @board[current_position].perform_moves(move_sequence)
  end

  def run


      @board.display
      make_move
      @board.display
      winner

  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.run
end
