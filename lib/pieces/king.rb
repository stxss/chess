require_relative("./../movement/directions")

class King
  include Directions

  def movement(board, start_position, piece)
    @board = board
    @start_position = start_position
    @piece = piece.piece
    @color = piece.color
    directions = [[-1, -1], [-1, 0], [-1, 1],
      [0, -1], [0, 1],
      [1, -1], [1, 0], [1, 1]] # up, down, left, right
    find_moves(:king, directions)
  end
end
