module Movement
  def can_move?(previous, following, available)
    @start_position = previous

    next_slot = @grid[following[0]][following[1]]

    valid_move?(available, following) && not_king?(next_slot.piece)
  end

  def move(prev_pos, piece, following)
    @grid[following[0]][following[1]] = piece
    @grid[prev_pos[0]][prev_pos[1]] = EmptySquare.new
  end

  def available_moves(grid, chosen, start_position)
    @moves = possible_moves(grid, start_position, chosen)
  end

  def possible_moves(board, start_position, piece)
    case piece.piece
    when PIECES[:king]
      King.new.movement(board, start_position, piece)
    when PIECES[:queen]
      Queen.new.movement(board, start_position, piece)
    when PIECES[:rook]
      Rook.new.movement(board, start_position, piece)
    when PIECES[:bishop]
      Bishop.new.movement(board, start_position, piece)
    when PIECES[:knight]
      Knight.new.movement(board, start_position, piece)
    when PIECES[:pawn]
      Pawn.new.movement(board, start_position, piece)
    end
  end

  def not_king?(piece)
    piece != PIECES[:king]
  end

  def valid_move?(available, following)
    available.include?(following)
  end
end
