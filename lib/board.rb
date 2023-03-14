require_relative("./text_styles")
require_relative("./pieces/piece")
require_relative("./pieces/queen")
require_relative("./pieces/rook")
require_relative("./pieces/bishop")
require_relative("./pieces/king")
require_relative("./pieces/knight")
require_relative("./pieces/pawn")
require_relative("./pieces/empty_square")
require_relative("./movement/movement")

class Board
  include Movement
  attr_accessor :grid, :white, :black, :pieces, :chosen, :moves

  def initialize
    @grid = Array.new(8) { Array.new(8, EmptySquare.new) }
    @black = []
    @white = []
  end

  def populate
    pieces_row(0, :black)
    pawn_row(1, :black)
    pawn_row(6, :white)
    pieces_row(7, :white)
  end

  private

  def pawn_row(row, color)
    pawn = Piece.new(:pawn, color)
    @grid[row].map! { pawn }

    distribute(pawn, color)
  end

  def pieces_row(row, color)
    rook = Piece.new(:rook, color)
    knight = Piece.new(:knight, color)
    bishop = Piece.new(:bishop, color)
    queen = Piece.new(:queen, color)
    king = Piece.new(:king, color)

    @pieces = [rook, knight, bishop, queen, king]

    @grid[row][0] = rook
    @grid[row][1] = knight
    @grid[row][2] = bishop
    @grid[row][3] = queen
    @grid[row][4] = king
    @grid[row][5] = bishop
    @grid[row][6] = knight
    @grid[row][7] = rook

    @pieces.each { |piece| distribute(piece, color) }
  end

  def distribute(piece, color)
    (color == :white) ? @white << piece : @black << piece
  end
end
