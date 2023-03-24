require_relative("piece")

class EmptySquare < Piece
  def initialize
    @painted = "   "
  end
end
