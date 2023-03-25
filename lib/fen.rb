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

  # def from_fen()
  #
  # end
end
