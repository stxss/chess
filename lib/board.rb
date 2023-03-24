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
require_relative("./movement/castling")
require_relative("./movement/pieces_moves")
require_relative("./movement/promotion")
require_relative("./movement/check_mate_stale")
require_relative("./movement/update_methods")

class Board
  include Movement
  attr_accessor :grid, :player1, :player2, :half_counter, :full_counter, :turn, :castles_white, :castles_black,
    :white_king, :white_moves, :black_king, :black_moves, :check, :checkmate, :stalemate

  def initialize
    @grid = Array.new(8) { Array.new(8, EmptySquare.new) }
    @half_counter, @full_counter, @turn = 0, 0, 0
    @castles_white = 0
    @castles_black = 0
  end

  def copy(board)
    Marshal.load(Marshal.dump(board))
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
    update_positions
  end

  private

  def pawn_row(row, color)
    @grid[row].map! { Piece.new(:pawn, color) }
  end

  def pieces_row(row, color)
    @grid[row][0] = Piece.new(:rook, color)
    @grid[row][1] = Piece.new(:knight, color)
    @grid[row][2] = Piece.new(:bishop, color)
    @grid[row][3] = Piece.new(:queen, color)
    @grid[row][4] = Piece.new(:king, color)
    @grid[row][5] = Piece.new(:bishop, color)
    @grid[row][6] = Piece.new(:knight, color)
    @grid[row][7] = Piece.new(:rook, color)
  end
end
