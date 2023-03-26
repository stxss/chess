require_relative("piece")

class EmptySquare < Piece
  def initialize
    @piece = "   "
    @painted = "   "
    @fen_notation = FEN[:empty]
  end
end
