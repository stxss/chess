require_relative("./../movement/movement")

class Bishop
  include Movement

  def movement(board, start_position, piece)
    @board = board
    @start_position = start_position
    @color = piece.color
    directions = [MOVE[:up_left], MOVE[:up_right], MOVE[:down_left], MOVE[:down_right]]

    piece.enemies = find_moves(:bishop, directions, :captures)
    piece.valid_moves = find_moves(:bishop, directions, :empty) + piece.enemies
  end
end
