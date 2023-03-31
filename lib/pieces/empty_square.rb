require_relative("piece")

class EmptySquare < Piece
  def initialize
    @piece = "   "
    @color = :empty
    @painted = "   "
    @fen_notation = FEN[:empty]
  end
end
