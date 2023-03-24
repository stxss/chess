module Fen
  def to_fen
    result = ""
    @board.grid.each_with_index do |i, row_index|
        empty_count = 0
      i.each_with_index do |piece, column_index|
        if piece.painted == "   "
          empty_count += 1
          next
        end
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
