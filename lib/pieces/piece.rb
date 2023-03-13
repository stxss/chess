require_relative("./../text_styles")
require_relative("./../movement/movement")

PIECES = {
  king:   " \u{265A} ",
  queen:  " \u{265B} ",
  rook:   " \u{265C} ",
  bishop: " \u{265D} ",
  knight: " \u{265E} ",
  pawn:   " \u{265F} "
}.freeze

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
