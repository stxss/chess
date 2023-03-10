require_relative("./../text_styles")

class Piece
  using TextStyles

  attr_accessor :valid_moves, :symbol

  def initialize(color)
    @valid_moves = []
    @symbol = (color == :white) ? white : black
  end
end
