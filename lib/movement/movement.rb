module Movement
  def can_move?(previous, following, available)
    @start_position = previous

    next_slot = @grid[following[0]][following[1]]

    valid_move?(available, following) && not_king?(next_slot.piece)
  end

  def move(prev_pos, piece, following)
    if piece.piece == PIECES[:pawn]
      piece = promote(piece.color) if (piece.color == :white && following[0] == 0) || (piece.color == :black && following[0] == 7)
    end
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

  def in_range?(position)
    position[0].between?(0, 7) && position[1].between?(0, 7)
  end

  def promote(color)
    piece = gets.chomp
    piece = case piece
    in "1" then :queen
    in "2" then :rook
    in "3" then :knight
    in "4" then :bishop
    end

    Piece.new(piece, color)
  end
end
