require_relative("piece")

class EmptySquare < Piece
  def initialize
    @painted = "   "
    @fen_notation = FEN[:empty]
  end
end
