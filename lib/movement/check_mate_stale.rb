module Movement
  # For when a piece checks the other player - used offensively
  def check?(white_moves = @white_moves, black_moves = @black_moves, white_king = @white_king, black_king = @black_king, color = :white)
    case color
    when :white
      @check = black_moves&.include?(white_king)
    when :black
      @check = white_moves&.include?(black_king)
    end
  end

  def mate_or_stale?(color)
    safe_moves = []
    @grid.each_with_index do |i, row|
      i.each_with_index do |piece, col|
        next if piece.color == color

        piece.valid_moves&.each do |move|
          safe_moves += safe_from_check?([row, col], piece)
        end
      end
    end

    @stalemate = safe_moves.uniq.flatten.empty? && !@check
    @checkmate = safe_moves.uniq.flatten.empty? && @check
  end
end
