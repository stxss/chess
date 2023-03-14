require_relative("./../movement/directions")

class Pawn
  include Directions

  def movement(board, start_position, piece)
    @board = board
    @start_position = start_position
    @piece = piece.piece
    @color = piece.color
    case @color
    when :white
      directions = [[-1, 0], [-2, 0]] # up, down, left, right
    when :black
      directions = [[1, 0], [2, 0]]
    end
    find_moves(:pawn, directions)
  end
end
