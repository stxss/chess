require_relative("./../text_styles")

PIECES = {
  rook:   " \u{265C} ",
  bishop: " \u{265D} ",
  knight: " \u{265E} ",
  queen:  " \u{265B} ",
  king:   " \u{265A} ",
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
