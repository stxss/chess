module Movement
  def castle_handler(color = :white, side = :king, purpose: :actual)
    return false if @check

    w_king, b_king = [7, 4], [0, 4]
    w_rook = (side == :king) ? [7, 7] : [7, 0]
    b_rook = (side == :king) ? [0, 7] : [0, 0]

    if purpose == :fen
      arr = []
      arr << no_moves?(w_king, [7, 7]) && not_under_attack?(:white, :king, @black_moves)
      arr << no_moves?(w_king, [7, 0]) && not_under_attack?(:white, :queen, @black_moves)
      arr << no_moves?(b_king, [0, 7]) && not_under_attack?(:black, :king, @black_moves)
      arr << no_moves?(b_king, [0, 0]) && not_under_attack?(:black, :queen, @black_moves)

      return arr
    end

    case color
    when :white
      castle(w_king, w_rook, side) if no_moves?(w_king,
        w_rook) && not_under_attack?(:white, side, @black_moves) && @castles_white < 1
    when :black
      castle(b_king, b_rook, side) if no_moves?(b_king,
        b_rook) && not_under_attack?(:black, side, @white_moves) && @castles_black < 1
    end
  end

  def no_moves?(k, r)
    @grid[k.first][k.last].piece == PIECES[:king] && @grid[r.first][r.last].piece == PIECES[:rook] && @grid[k.first][k.last].made_moves.empty? && @grid[r.first][r.last].made_moves.empty?
  end

  def not_under_attack?(color, side, opponent_moves)
    to_verify = CASTLE_VARS[color][side]

    castle_checks = []
    to_verify.each do |square|
      castle_checks << (empty?(square, board: self) && opponent_moves.none?(square))
    end
    castle_checks.all?(true)
  end

  def castle(k, r, side)
    case side
    when :king
      @grid[k.first][k.last + 2] = @grid[k.first][k.last]
      @grid[r.first][r.last - 2] = @grid[r.first][r.last]
    when :queen
      @grid[k.first][k.last - 2] = @grid[k.first][k.last]
      @grid[r.first][r.last + 3] = @grid[r.first][r.last]
    end

    castled_color = @grid[k.first][k.last].color
    update_full(castled_color)

    @grid[k.first][k.last] = EmptySquare.new
    @grid[r.first][r.last] = EmptySquare.new

    @half_counter += 1
    update_turn
    (castled_color == :white) ? @castles_white += 1 : @castles_black += 1
  end
end
