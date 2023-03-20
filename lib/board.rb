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
  attr_accessor :grid, :player1, :player2, :half_counter, :full_counter, :turn

  def initialize
    @grid = Array.new(8) { Array.new(8, EmptySquare.new) }
    @half_counter, @full_counter, @turn = 0, 0, 0
  end

  def create_scoreboard(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def populate
    pieces_row(0, :black)
    pawn_row(1, :black)
    pawn_row(6, :white)
    pieces_row(7, :white)
  end

  private

  def pawn_row(row, color)
    @grid[row].map! { Piece.new(:pawn, color) }
  end

  def pieces_row(row, color)
    rook = Piece.new(:rook, color)
    knight = Piece.new(:knight, color)
    bishop = Piece.new(:bishop, color)
    queen = Piece.new(:queen, color)
    king = Piece.new(:king, color)

    @grid[row][0] = rook
    @grid[row][1] = knight
    @grid[row][2] = bishop
    @grid[row][3] = queen
    @grid[row][4] = king
    @grid[row][5] = bishop
    @grid[row][6] = knight
    @grid[row][7] = rook
  end
end
