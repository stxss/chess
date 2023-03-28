module Movement
  def valid_movements(piece, initial)
    @valids = possible_moves(initial, piece)&.intersection(safe_from_check?(initial, piece))
  end

  def possible_moves(cursor_position, piece)
    case piece.piece
    when PIECES[:king]
      King.new.movement(self, cursor_position, piece)
    when PIECES[:queen]
      Queen.new.movement(self, cursor_position, piece)
    when PIECES[:rook]
      Rook.new.movement(self, cursor_position, piece)
    when PIECES[:bishop]
      Bishop.new.movement(self, cursor_position, piece)
    when PIECES[:knight]
      Knight.new.movement(self, cursor_position, piece)
    when PIECES[:pawn]
      Pawn.new.movement(self, cursor_position, piece)
    end
  end

  def all_moves(color, board)
    moves = []
    update_positions
    @grid.flatten.each do |piece|
      moves += possible_moves(piece.position, piece) if piece.color == color
    end
    moves
  end

  def update_moves_when_check
    @grid.each_with_index do |i, row_index|
      i.each_with_index do |piece, column_index|
        next if piece.piece == "   "

        piece.valid_moves = safe_from_check?([row_index, column_index], piece)
        p piece
        p piece.valid_moves
        p safe_from_check?([row_index, column_index], piece)
        # sleep(5)
        p piece.valid_moves
        # if !piece.valid_moves&.intersection(safe_from_check?([row_index, column_index], piece))

        # end
      end
    end
  end

  def find_king(color)
    @grid.flatten.find do |piece|
      piece.piece == PIECES[:king] && piece.color == color
    end&.position
  end

  def can_move?(following, available)
    next_slot = @grid[following.first][following.last]
    available.include?(following) && next_slot.piece != PIECES[:king]
  end

  def move(prev_pos, piece, following, goal)
    if piece.piece == PIECES[:pawn]
      piece = promote(piece.color) if to_be_promoted(piece.color, following&.first) && goal != :ghost
    end

    update_half(piece, following)
    update_full(@grid[prev_pos.first][prev_pos.last].color)
    update_turn

    piece.made_moves << [following.first - prev_pos.first, following.last - prev_pos.last]
    piece.when_jumped << @turn

    update_piece(piece, prev_pos, following)
    update_all_moves(self)
    update_ep_flags
  end

  def annotate_moves(drawing, color, previous, following)
    piece = PIECES.key(drawing)
    fen_piece = FEN[color][piece]

    capture = following_color != color && following_color && !empty?(following, board: self)

    @translated_jumps[@turn] = [fen_piece, previous, capture, following, @check, @checkmate, @stalemate]
  end

  def safe_from_check?(initial, piece, board: self)
    ghost_board = Board.new.copy(board)

    ghost_piece = ghost_board.grid[initial.first][initial.last]

    safe = []

    ghost_piece&.valid_moves&.each do |move|
      ghost_board.move(initial, ghost_piece, move, :ghost)
      ghost_board.update_all_moves(ghost_board)

      safe << move if !ghost_board.in_check?(ghost_board.white_moves, ghost_board.black_moves, ghost_board.white_king,
        ghost_board.black_king, ghost_piece.color)

      ghost_board.move(move, ghost_piece, initial, :ghost)
      ghost_board.update_all_moves(ghost_board)
    end
    safe
  end

  def in_range?(position)
    position.first.between?(0, 7) && position.last.between?(0, 7)
  end
end
