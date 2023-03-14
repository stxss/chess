require_relative("./../movement/directions")

class Bishop
  include Directions

  def movement(board, start_position, piece)
    @board = board
    @start_position = start_position
    @piece = piece.piece
    @color = piece.color
    directions = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
    find_moves(:bishop, directions)
  end
end
