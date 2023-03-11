require_relative("./text_styles")
require_relative("./pieces/piece")
require_relative("./pieces/queen")
require_relative("./pieces/rook")
require_relative("./pieces/bishop")
require_relative("./pieces/king")
require_relative("./pieces/knight")
require_relative("./pieces/pawn")
require_relative("./pieces/empty_square")

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8, EmptySquare.new.symbol) }
  end

  def populate
    pieces_row(0, :black)
    pawn_row(1, :black)
    pawn_row(6, :white)
    pieces_row(7, :white)
  end

  def pawn_row(row, color)
    @grid[row].map! { Pawn.new(color).symbol }
  end

  def pieces_row(row, color)
    @grid[row][0] = Rook.new(color).symbol
    @grid[row][1] = Bishop.new(color).symbol
    @grid[row][2] = Knight.new(color).symbol
    @grid[row][3] = Queen.new(color).symbol
    @grid[row][4] = King.new(color).symbol
    @grid[row][5] = Bishop.new(color).symbol
    @grid[row][6] = Knight.new(color).symbol
    @grid[row][7] = Rook.new(color).symbol
  end
end
