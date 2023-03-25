require_relative("./../text_styles")
require_relative("./../movement/movement")

class Piece
  include Movement
  using TextStyles

  attr_accessor :valid_moves, :painted, :color, :piece, :made_moves, :when_jumped, :ep_flag, :enemies, :position, :fen_notation

  def initialize(piece, color)
    @position = []
    @valid_moves = []
    @enemies = []
    @color = color
    @piece = PIECES[piece]
    @painted = paint(color)
    @made_moves = [] # specifically made for en_passant and castling
    @when_jumped = []
    @ep_flag = false # specifically made for en_passant
    @fen_notation = FEN[color][piece]
  end

  def paint(color)
    @piece.fg_color(color)
  end
end
