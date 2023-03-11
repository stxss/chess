require_relative("piece")

class EmptySquare < Piece
  def initialize
    @symbol = "   "
  end
end
