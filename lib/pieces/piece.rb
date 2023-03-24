require_relative("./../text_styles")
require_relative("./../movement/movement")

class Piece
  include Movement
  using TextStyles

  attr_accessor :valid_moves, :painted, :color, :piece, :made_moves, :when_jumped, :ep_flag, :enemies

  def initialize(piece, color)
    @valid_moves = []
    @enemies = []
    @color = color
    @piece = PIECES[piece]
    @painted = paint(color)
    @made_moves = [] # specifically made for en_passant
    @when_jumped = []
    @ep_flag = false
  end

  def paint(color)
    @piece.fg_color(color)
  end
end
