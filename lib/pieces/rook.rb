require_relative("./../movement/directions")

class Rook
  include Directions::Vertical
  include Directions::Horizontal

  def movement(board, start_position, piece)
    @board = board
    @start_position = start_position
    @piece = piece

    vertical + horizontal
  end
end
