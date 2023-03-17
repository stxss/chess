require_relative("./../text_styles")
require_relative("./../movement/movement")

class Piece
  using TextStyles

  attr_accessor :valid_moves, :symbol, :color, :piece

  def initialize(piece, color)
    @valid_moves = []
    @color = color
    @piece = PIECES[piece]
    @symbol = paint(color)
  end

  def paint(color)
    @piece.fg_color(color)
  end
end
