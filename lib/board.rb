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
require_relative("./movement/en_passant")
require_relative("./movement/pieces_moves")
require_relative("./movement/promotion")
require_relative("./movement/check_mate_stale")
require_relative("./movement/update_methods")

class Board
  include Movement
  attr_accessor :grid, :player1, :player2, :half_counter, :full_counter, :turn, :castles_white, :castles_black,
    :white_king, :white_moves, :black_king, :black_moves, :check, :checkmate, :stalemate, :saved, :filename, :translated_jumps, :promo, :pass_through

  def initialize(starting_fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    @grid = Array.new(8) { Array.new(8, EmptySquare.new) }
    @half_counter, @full_counter, @turn = 0, 1, 0
    @fen = starting_fen
    read_from_fen(starting_fen)
    @castles_white = 0
    @castles_black = 0
    @saved = false
    @filename = ""
    @translated_jumps = {}
    @promo = true # this one is made specifically to avoid bugs with the annotation
    @pass_through = true # this one is made specifically to avoid bugs with the annotation
  end

  def copy(board)
    Marshal.load(Marshal.dump(board))
  end

  def create_scoreboard(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def read_from_fen(fen = "")
    populate(fen.split[0])
    @half_counter = fen.split[4].to_i
    @full_counter = fen.split[5].to_i
    @castles_white = fen.split[6]
    @castles_black = fen.split[7]
  end

  def populate(fen)
    rows = fen.split("/")

    @grid.each_with_index do |i, row_index|
      i.each_with_index do |piece, column_index|
        rows[row_index].gsub!(/[1-8]/) { |num| "1" * num.to_i }

        next if rows[row_index][column_index] == "1"

        each_row = rows[row_index].chars
        color = (each_row[column_index]&.upcase == each_row[column_index]) ? :white : :black
        to_insert = TRANSLATE[each_row[column_index]]
        @grid[row_index][column_index] = Piece.new(to_insert, color)
      end
    end
  end
end
