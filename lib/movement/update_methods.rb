module Movement
  def update_piece(piece, previous, following)
    if piece.piece == PIECES[:pawn]
      handle_ep(piece, previous, following)
    end

    @grid[following.first][following.last] = piece
    @grid[previous.first][previous.last] = EmptySquare.new
  end

  def update_all_moves(board)
    @white_moves = all_moves(:white, board)
    @white_king = find_king(:white)
    @black_moves = all_moves(:black, board)
    @black_king = find_king(:black)
    update_positions
  end

  def update_positions
    @grid.each_with_index do |i, row_index|
      i.each_with_index do |piece, column_index|
        piece.position = [row_index, column_index]
      end
    end
  end

  def update_ep_flags # this and own_ep_check were made specifically to help with the FEN serialization
    @grid.each_with_index do |i, row_index|
      i.each_with_index do |piece, column_index|
        if piece.piece == PIECES[:pawn]
          own_ep_check(piece, piece.position, piece.color)
        end
      end
    end
  end

  end

  def update_full(color)
    @full_counter += 1 if color == :black
  end

  def update_turn
    @turn += 1
  end
end
