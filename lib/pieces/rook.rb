require_relative("./../movement/directions")
require_relative("./../pieces/empty_square")

class Rook
  include Directions

  def movement(board, start_position, piece)
    @board = board
    @start_position = start_position
    @piece = piece.piece
    @color = piece.color
    directions = [[-1, 0], [1, 0], [0, -1], [0, 1]] # up, down, left, right
    find_moves(:rook, directions)
  end
end
