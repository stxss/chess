require_relative("./../movement/directions")

class Queen
  include Directions

  def movement(board, start_position, piece)
    @board = board
    @start_position = start_position
    @piece = piece.piece
    @color = piece.color
    directions = [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]] # up, down, left, right, up_left, up_right, down_left, down_right
    find_moves(:queen, directions)
  end
end
