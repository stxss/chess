require_relative("./text_styles")
require_relative("./pieces/piece")
require_relative("./pieces/queen")
require_relative("./pieces/rook")
require_relative("./pieces/bishop")
require_relative("./pieces/king")
require_relative("./pieces/knight")
require_relative("./pieces/pawn")

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8, Array.new(8, "   "))
  end
end
