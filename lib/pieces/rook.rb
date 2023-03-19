require_relative("./../movement/directions")
require_relative("./../pieces/empty_square")

class Rook
  include Directions

  def movement(board, start_position, piece)
    @board = board
    @start_position = start_position
    @piece = piece.piece
    @color = piece.color
    directions = [MOVE[:up], MOVE[:down], MOVE[:left], MOVE[:right]]

    piece.enemies = find_moves(:rook, directions, :captures)
    piece.valid_moves = find_moves(:rook, directions, :empty) + piece.enemies
  end
end
