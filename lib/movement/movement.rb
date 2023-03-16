module Movement
  def can_move?(previous, following, available)
    @start_position = previous

    next_slot = @grid[following[0]][following[1]]

    valid_move?(available, following) && not_king?(next_slot.piece)
  end

  def move(prev_pos, piece, following)
    if piece.piece == PIECES[:pawn]
      piece = promote(piece.color) if to_be_promoted(piece.color, following[0])
    end

    update_half(following[0], following[1])
    update_full(@grid[prev_pos[0]][prev_pos[1]].color)
    update_turn
    update_piece(piece, prev_pos, following)
  end

  def available_moves(grid, chosen, start_position)
    @moves = possible_moves(grid, start_position, chosen)
  end

  def in_range?(position)
    position[0].between?(0, 7) && position[1].between?(0, 7)
  end

  def is_empty?(row, column)
    @grid[row][column].instance_of?(EmptySquare)
  end

  private

  def valid_move?(available, following)
    available.include?(following)
  end

  def not_king?(piece)
    piece != PIECES[:king]
  end

  def to_be_promoted(color, row)
    color == :white && row == 0 || color == :black && row == 7
  end

  def promote(color)
    # TODO add prompt for piece promotion
    piece = gets.chomp
    piece = case piece
    in "1" then :queen
    in "2" then :rook
    in "3" then :knight
    in "4" then :bishop
    end

    Piece.new(piece, color)
  end

  def update_half(row, col)
    is_empty?(row, col) ? @half_counter += 1 : @half_counter = 0
  end

  def update_full(color)
    @full_counter += 1 if color == :black
  end

  def update_turn
    @turn += 1
  end

  def update_piece(piece, previous, following)
    @grid[following[0]][following[1]] = piece
    @grid[previous[0]][previous[1]] = EmptySquare.new
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
end
