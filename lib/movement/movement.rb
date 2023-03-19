module Movement
  def can_move?(following, available)
    next_slot = @grid[following.first][following.last]
    valid_move?(available, following) && not_king?(next_slot.piece)
  end

  def move(prev_pos, piece, following)
    if piece.piece == PIECES[:pawn]
      piece = promote(piece.color) if to_be_promoted(piece.color, following.first)
    end

    update_half(following)
    update_full(@grid[prev_pos.first][prev_pos.last].color)
    update_turn

    piece.made_moves << [following.first - prev_pos.first, following.last - prev_pos.last]
    piece.when_jumped << @turn
    update_piece(piece, prev_pos, following)
  end

  def in_range?(position)
    position.first.between?(0, 7) && position.last.between?(0, 7)
  end

  def is_empty?(position)
    @grid[position.first][position.last].instance_of?(EmptySquare)
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

  def update_piece(piece, previous, following)
    if piece.piece == PIECES[:pawn]
      handle_ep(piece, previous, following)
    end

    @grid[following.first][following.last] = piece
    @grid[previous.first][previous.last] = EmptySquare.new
  end

  def handle_ep(piece, previous, following)
    case piece.color
    when :white
      @grid[following.first + 1][following.last] = EmptySquare.new if @grid[following.first + 1][following.last].ep_flag
    when :black
      @grid[following.first - 1][following.last] = EmptySquare.new if @grid[following.first - 1][following.last].ep_flag
    end
    @grid[following.first][following.last] = piece
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

  def update_half(position)
    is_empty?(position) ? @half_counter += 1 : @half_counter = 0
  end

  def update_full(color)
    @full_counter += 1 if color == :black
  end

  def update_turn
    @turn += 1
  end
end
