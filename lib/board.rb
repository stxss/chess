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

  private

  def pawn_row(row, color)
    @grid[row].map! { Piece.new(:pawn, color).symbol }
  end

  def pieces_row(row, color)
    @grid[row][0] = Piece.new(:rook, color).symbol
    @grid[row][1] = Piece.new(:knight, color).symbol
    @grid[row][2] = Piece.new(:bishop, color).symbol
    @grid[row][3] = Piece.new(:queen, color).symbol
    @grid[row][4] = Piece.new(:king, color).symbol
    @grid[row][5] = Piece.new(:bishop, color).symbol
    @grid[row][6] = Piece.new(:knight, color).symbol
    @grid[row][7] = Piece.new(:rook, color).symbol
  end
end
