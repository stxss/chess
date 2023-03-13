module Movement
  def can_move?(previous, piece, following)
    @start_position = previous
    curr_color = @white.any?(piece) ? "white" : "black"

    next_slot = @grid[following[0]][following[1]]
    next_color = if @white.any?(next_slot)
      "white"
    elsif @black.any?(next_slot)
      "black"
    else
      "empty"
    end

    (curr_color != next_color || next_color == "empty") && following != @initial_pos
  end

  def move(prev_pos, piece, following)
    @grid[following[0]][following[1]] = piece
    @grid[prev_pos[0]][prev_pos[1]] = EmptySquare.new
  end

  def available_moves(grid, chosen, start_position)
    @moves = possible_moves(grid, start_position, chosen.piece)
  end

  def possible_moves(board, start_position, piece)
    if piece == PIECES[:king]
      King.new.movement(board, start_position, piece)
    elsif piece == PIECES[:queen]
      Queen.new.movement(board, start_position, piece)
    elsif piece == PIECES[:rook]
      Rook.new.movement(board, start_position, piece)
    elsif piece == PIECES[:bishop]
      Bishop.new.movement(board, start_position, piece)
    elsif piece == PIECES[:knight]
      Knight.new.movement(board, start_position, piece)
    elsif piece == PIECES[:pawn]
      Pawn.new.movement(board, start_position, piece)
    end
  end
end
