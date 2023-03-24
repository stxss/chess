require_relative("./../movement/movement")

class Knight
  include Movement

  def movement(board, start_position, piece)
    @board = board
    @start_position = start_position
    @color = piece.color
    directions = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]

    piece.enemies = find_moves(:knight, directions, :captures)
    piece.valid_moves = find_moves(:knight, directions, :empty) + piece.enemies
  end
end
