require_relative("./../movement/directions")

class King
  include Directions

  def movement(board, start_position, piece)
    @board = board
    @start_position = start_position
    @piece = piece.piece
    @color = piece.color
    directions = [MOVE[:up], MOVE[:down], MOVE[:left], MOVE[:right], MOVE[:up_left], MOVE[:up_right], MOVE[:down_left],
      MOVE[:down_right]]
    find_moves(:king, directions)
  end
end
