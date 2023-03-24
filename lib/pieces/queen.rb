require_relative("./../movement/movement")

class Queen
  include Movement

  def movement(board, start_position, piece)
    @board = board
    @start_position = start_position
    @color = piece.color
    directions = [MOVE[:up], MOVE[:down], MOVE[:left], MOVE[:right], MOVE[:up_left], MOVE[:up_right], MOVE[:down_left],
      MOVE[:down_right]]

    piece.enemies = find_moves(:queen, directions, :captures)
    piece.valid_moves = find_moves(:queen, directions, :empty) + piece.enemies
  end
end
