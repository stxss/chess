module Fen
  def to_fen
    piece_placement + active_color + castling_rights + en_passant_targets + half_moves + full_moves
  end

  def piece_placement
    result = ""
    @board.grid.each_with_index do |i, row_index|
      empty_count = 0
      i.each_with_index do |piece, column_index|
        if piece.painted == "   "
          empty_count += 1
          next
        end

        result << empty_count.to_s unless empty_count.zero?
        empty_count = 0
        result << piece.fen_notation.to_s
      end
      result << empty_count.to_s unless empty_count.zero?
      result << "/" unless row_index == 7
    end
    result
  end

  def active_color
    @board.turn.even? ? " w" : " b"
  end

  def castling_rights
    rights = @board.castle_handler(purpose: :fen)

    return " -" if rights.all?(false)

    output = " "
    output << "K" if rights[0] && @board.castles_white < 1
    output << "Q" if rights[1] && @board.castles_white < 1
    output << "k" if rights[2] && @board.castles_black < 1
    output << "q" if rights[3] && @board.castles_black < 1

    output
  end

  
  # def from_fen()
  #
  # end
end
