module Movement
  def can_move?(following, available)
    next_slot = @grid[following.first][following.last]
    valid_move?(available, following) && not_king?(next_slot.piece)
  end

  def move(prev_pos, piece, following, goal)
    if piece.piece == PIECES[:pawn]
      piece = promote(piece.color) if to_be_promoted(piece.color, following.first) && goal != :test
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

  def is_check?(white_moves, black_moves, white_king, black_king, color)
    case color
    when :white
      @check = black_moves&.include?(white_king)
    when :black
      @check = white_moves&.include?(black_king)
    end
  end

  def checks?
    @check = @black_moves&.include?(@white_king) || @white_moves&.include?(@black_king)
  end

  def update_all_moves(board)
    @white_moves = all_moves(:white, board)
    @white_king = find_king(:white)
    @black_moves = all_moves(:black, board)
    @black_king = find_king(:black)
  end

  def find_king(color)
    @grid.each_with_index do |i, row|
      i.each_with_index do |piece, column|
        character = piece.piece
        return [row, column] if character == PIECES[:king] && piece.color == color
      end
    end
  end

  def all_moves(color, board)
    arr = []
    @grid.each_with_index do |i, row|
      i.each_with_index do |piece, column|
        arr += possible_moves(board, [row, column], piece) if piece.color == color
      end
    end
    arr
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

  def castle_handler(color, side, white_moves, black_moves)
    w_king, b_king = [7, 4], [0, 4]

    w_rook = (side == :king) ? [7, 7] : [7, 0]
    b_rook = (side == :king) ? [0, 7] : [0, 0]
    case color
    when :white
      castle(w_king, w_rook, side) if no_moves?(w_king,
        w_rook) && not_under_attack?(:white, side, black_moves) && !@check && @castles_white < 1
    when :black
      castle(b_king, b_rook, side) if no_moves?(b_king,
        b_rook) && not_under_attack?(:black, side, white_moves) && !@check && @castles_black < 1
    end
  end

  def no_moves?(k, r)
    @grid[k.first][k.last].piece == PIECES[:king] && @grid[r.first][r.last].piece == PIECES[:rook] && @grid[k.first][k.last].made_moves.empty? && @grid[r.first][r.last].made_moves.empty?
  end

  def not_under_attack?(color, side, opponent_moves)
    if color == :white && side == :king
      to_verify = [[7, 5], [7, 6]]
    elsif color == :white && side == :queen
      to_verify = [[7, 3], [7, 2], [7, 1]]
    elsif color == :black && side == :king
      to_verify = [[0, 5], [0, 6]]
    elsif color == :black && side == :queen
      to_verify = [[0, 3], [0, 2], [0, 1]]
    end
    no_castle_checks?(opponent_moves, to_verify)
  end

  def no_castle_checks?(opponent, to_verify)
    castle_checks = []
    to_verify.each do |square|
      castle_checks << (is_empty?(square) && opponent.none?(square))
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
    puts "Please select the piece you want to replace your pawn with:"
    until (piece = gets.chomp) =~ /[1-4]/
      puts "\nRemember that you must select a number from 1-4, as stipulated by the rules above.\nPlease select the piece you want to replace your pawn with:"
    end

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
