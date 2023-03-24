require_relative("./../movement/movement")

class Rook
  include Movement

  def movement(board, start_position, piece)
    @board = board
    @start_position = start_position
    @color = piece.color
    directions = [MOVE[:up], MOVE[:down], MOVE[:left], MOVE[:right]]

    piece.enemies = find_moves(:rook, directions, :captures)
    piece.valid_moves = find_moves(:rook, directions, :empty) + piece.enemies
  end
end
