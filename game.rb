require_relative "board.rb"
require_relative "piece.rb"
require "byebug"

class Game

  def initialize
    @board = Board.new
  end

  def won?
    pieces = @board.rows.flatten.compact

    if pieces.none? {|piece| piece.color == :white}
      return true
    elsif pieces.none? {|piece| piece.color == :black}
      return true
    else
      return false
    end
  end

  # def won?
  #   if winner == nil?
  #     return false
  #   else
  #     return true
  #   end
  # end

  def make_move
    move_sequence = []

    puts "Select a piece"
    current_position = gets.chomp.split(',').map(&:to_i)

    puts "Would you like to make multiple moves?(Y/N)"
    a = gets.chomp
    if a == "N"
      puts "Enter Move"
      boom = [gets.chomp.split(',').map(&:to_i)]
      @board[current_position].perform_moves(boom)
    else
      loop do
        puts "Enter Move. Type finished to stop"
        c = gets.chomp
        if c == "finished"
          break
        else
          move_sequence <<  c.split(',').map(&:to_i)
        end
      end
      @board[current_position].perform_moves(move_sequence)
    end
  end

  def run

    until won?
      @board.display
      make_move
      @board.display
    end

    "You won!"
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.run
end
