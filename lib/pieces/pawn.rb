require_relative("./../movement/movement")

class Pawn
  include Movement

  attr_accessor :normal_moves, :ep_flag

  def movement(board, start_position, piece)
    @board = board
    @start_position = start_position

    @color = piece.color
    @jumps_done = piece.made_moves

    @row = @start_position[0]
    @col = @start_position[1]

    @moves_w_passant = []

    case @color
    when :white
      jump1, jump2 = MOVE[:up], [-2, 0]
      enemy_directions = [MOVE[:up_left], MOVE[:up_right]]
    when :black
      jump1, jump2 = MOVE[:down], [2, 0]
      enemy_directions = [MOVE[:down_left], MOVE[:down_right]]
    end

    check_passant(@color) if conditions_passant?(@color)

    directions = if no_immediate_piece?(@color) && moved_once?(@color)
      [jump1]
    elsif no_immediate_piece?(@color) && !moved_once?(@color)
      [jump1, jump2]
    else
      []
    end

    piece.enemies = find_moves(:pawn, enemy_directions, :captures)
    @normal_moves = find_moves(:pawn, directions, :empty) + piece.enemies
    piece.valid_moves = @enemy_ep_flag ? @moves_w_passant + @normal_moves : @normal_moves
  end

  def check_passant(color)
    passant_enemies(color) if (color == :white && @row == 3) || (color == :black && @row == 4)
  end

  private

  def moved_once?(color)
    # starting pawn rows, column is not relevant for this check
    w_pawn_start, b_pawn_start = 6, 1

    @row != ((color == :white) ? w_pawn_start : b_pawn_start)
  end

  def no_immediate_piece?(color)
    (color == :white) ? empty?([@row - 1, @col]) : empty?([@row + 1, @col])
  end

  def conditions_passant?(color)
    case color
    when :white
      cond1 = empty?([@row - 1, @col - 1]) || empty?([@row - 1, @col + 1])
    when :black
      cond1 = empty?([@row + 1, @col - 1]) || empty?([@row + 1, @col + 1])
    end

    if cond1 && @col.between?(0, 7)
      is_pawn?([@row, @col - 1]) || is_pawn?([@row, @col + 1])
    end
  end

  def passant_enemies(color)
    col_to_check = @col - 1 if enemy?(color, [@row, @col - 1])
    col_to_check = @col + 1 if enemy?(color, [@row, @col + 1])

    if enemy?(color, [@row, @col - 1]) && enemy?(color, [@row, @col + 1])
      return if !is_pawn?([@row, @col - 1])
      return if !is_pawn?([@row, @col + 1])

      jump_left = @board.grid[@row][@col - 1].when_jumped[0]
      jump_right = @board.grid[@row][@col + 1].when_jumped[0]
      col_to_check = (jump_left > jump_right) ? @col - 1 : @col + 1
    end

    return if col_to_check.nil?

    enemy_jumps = @board.grid[@row][col_to_check].made_moves

    if valid_passant?(color, enemy_jumps, [@row, col_to_check])
      @moves_w_passant << ((color == :white) ? [@row - 1, col_to_check] : [@row + 1, col_to_check])
    end
  end

  def valid_passant?(color, enemy_jumps, square)
    @enemy_ep_flag = @board.grid[square.first][square.last].ep_flag
  end

  def is_pawn?(position)
    return false if !(position[1] - 1).between?(0, 7) || !(position[1] + 1).between?(0, 7)

    @board.grid[position[0]][position[1]].piece == PIECES[:pawn]
  end
end
