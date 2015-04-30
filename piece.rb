require 'byebug'

class InvalidMoveError < ArgumentError; end

class Piece
  attr_reader :color
  attr_accessor :king, :position, :board

  SLIDE_MOVES = {:W => [[-1,-1], [-1,1]], :B => [[1,-1], [1,1]]}
  JUMP_MOVES = {:W => [[-2,2], [-2,-2]], :B => [[2,-2], [2,2]]}
  KING_SLIDE_MOVES = [[-1,-1], [-1,1], [1,-1], [1,1]]
  KING_JUMP_MOVES = [[-2,2], [-2,-2], [2,-2], [2,2]]

  def initialize(board, position, color, king = false)
    @board = board
    @position = position
    @color = color
    @king = king
  end

  def explore_slide_moves(move)
    move_row, move_col = move[0], move[1]

    potential_move = [@position[0] + move_row, @position[1] + move_col]

    return [] if on_board?(potential_move) == false

    if @board[potential_move].nil?
      [potential_move]
    else
      []
    end
  end

  def explore_jump_moves(move)
    move_row, move_col = move[0], move[1]
    potential_move = [@position[0] + move_row, @position[1] + move_col]

    return [] if on_board?(potential_move) == false

    mid_row = (potential_move[0]+@position[0])/2
    mid_col = (potential_move[1]+@position[1])/2
    middle_pos = [mid_row,mid_col]
    potential_move = [@position[0] + move_row, @position[1] + move_col]

    if @board[middle_pos] != nil
      if @board[potential_move].nil? && @board[middle_pos].color != self.color
        return [potential_move]
      end
    end
    []
  end

  def inspect
    @color
  end

  def maybe_promote
    if @color == :W && @position[0] == 0
      @king = true
    elsif color == :B && @position[0] == 7
      @king = true
    end
    nil
  end

  def on_board?(pos)
    row = pos[0]
    col = pos[1]

    if row >= 0 && row <= 7
      if col >= 0 || col <= 7
        return true
      end
    end
    false
  end

  def perform_slide(destination)
    return false if !valid_moves.include?(destination)

    @board[@position] = nil
    @board[destination] = self

    @position = destination
    true
  end

  def perform_jump(destination)
    return false if !self.valid_moves.include?(destination)

    mid_row = (@position[0] + destination[0]) / 2
    mid_col = (@position[1] + destination[1]) / 2
    middle_pos = [mid_row, mid_col]

    @board[@position] = nil
    @board[middle_pos] = nil
    @board[destination] = self

    @position = destination

    true
  end

  def perform_moves(move_sequence)
    if valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise InvalidMoveError.new"Invalid Move Sequence"
    end
  end

  def perform_moves!(move_sequence)
    if move_sequence.length == 1
      perform_slide(move_sequence[0]) || perform_jump(move_sequence[0]) ||
        (raise InvalidMoveError.new"Invalid Move Sequence")
    else
      move_sequence.each do |move|
        if perform_jump(move) == false
          raise InvalidMoveError.new"Invalid Move Sequence"
        end
      end
    end
  end

  def valid_moves
      valid_moves = []

      if @king == true
        KING_SLIDE_MOVES.each do |move|
          valid_moves += explore_slide_moves(move)
        end

        KING_JUMP_MOVES.each do |move|
          valid_moves += explore_jump_moves(move)
        end
      else
        SLIDE_MOVES[@color].each do |move|
          valid_moves += explore_slide_moves(move)
        end
        JUMP_MOVES[@color].each do |move|
          valid_moves += explore_jump_moves(move)
        end
      end
    valid_moves
  end

  def valid_move_seq?(move_sequence)
    dup_board = @board.deep_dup

    begin
      dup_board[self.position].perform_moves!(move_sequence)
      true
    rescue InvalidMoveError
      false
    end
  end
end
