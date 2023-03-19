require_relative("./../movement/directions")

class Pawn
  include Directions

  attr_accessor :moves, :ep_flag

  def movement(board, start_position, piece)
    @board = board
    @start_position = start_position
    @piece = piece.piece
    @color = piece.color
    @jumps_done = piece.made_moves

    @row = @start_position[0]
    @col = @start_position[1]

    @moves = []
    @moves_w_passant = []
    @ep_flag = false

    case @color
    when :white
      jump1, jump2 = MOVE[:up], [-2, 0]
      enemy_directions = [MOVE[:up_left], MOVE[:up_right]]
      # en_passant?(@color) if (empty?([@row - 1, @col - 1]) || empty?([@row - 1, @col + 1])) && ((@col - 1).between?(0, 7) && (@col + 1).between?(0, 7)) && (is_pawn?([@row, @col - 1]) || is_pawn?([@row, @col + 1]))
      en_passant?(@color) if conditions_passant?(@color)
    when :black
      jump1, jump2 = MOVE[:down], [2, 0]
      enemy_directions = [MOVE[:down_left], MOVE[:down_right]]
      # en_passant?(@color) if empty?([@row + 1, @col - 1]) || empty?([@row + 1, @col + 1]) && ((@col - 1).between?(0, 7) && (@col + 1).between?(0, 7)) && (is_pawn?([@row, @col - 1]) || is_pawn?([@row, @col + 1]))
      en_passant?(@color) if conditions_passant?(@color)
    end

    directions = if !has_immediate_enemy?(@color) && moved_once?(@color)
      [jump1]
    elsif !has_immediate_enemy?(@color) && !moved_once?(@color)
      [jump1, jump2]
    else
      []
    end

    @moves = find_moves(:pawn, directions) + pawn_enemies(@color, enemy_directions)

    piece.valid_moves = @ep_flag ? @moves_w_passant + @moves : @moves
  end

  def en_passant?(color)
    passant_enemies(color) if color == :white && @row == 3 || color == :black && @row == 4
  end

  private

  def moved_once?(color)
    # starting pawn rows, column is not relevant for this check
    w_pawn_start = 6
    b_pawn_start = 1

    case color
    when :white
      @row != w_pawn_start
    when :black
      @row != b_pawn_start
    end
  end

  def has_immediate_enemy?(color)
    case color
    when :white
      enemy?(color, [@row - 1, @col])
    when :black
      enemy?(color, [@row + 1, @col])
    end
  end

  def pawn_enemies(color, directions)
    enemies = []

    directions.each do |direction|
      next_row = @row + direction[0]
      next_col = @col + direction[1]

      unless next_col == 8
        enemies << [next_row, next_col] if enemy?(color, [next_row, next_col])
      end
    end
    enemies
  end

  def conditions_passant?(color)
    # return false if !(@col - 1).between?(0, 7) || !(@col + 1).between?(0, 7)

    case color
    when :white
      cond1 = empty?([@row - 1, @col - 1]) || empty?([@row - 1, @col + 1])
    when :black
      cond1 = empty?([@row + 1, @col - 1]) || empty?([@row + 1, @col + 1])
    end

    if cond1
      if @col.between?(0, 7)
        is_pawn?([@row, @col - 1]) || is_pawn?([@row, @col + 1])
      end
    end
  end

  def passant_enemies(color)
    # return false if !(@col - 1).between?(0, 7) || !(@col + 1).between?(0, 7)

    col_to_check = @col - 1 if enemy?(color, [@row, @col - 1])
    col_to_check = @col + 1 if enemy?(color, [@row, @col + 1])

    if enemy?(color, [@row, @col - 1]) && enemy?(color, [@row, @col + 1])
      jump_left = @board.grid[@row][@col - 1].when_jumped[0]
      jump_right = @board.grid[@row][@col + 1].when_jumped[0]
      col_to_check = (jump_left > jump_right) ? @col - 1 : @col + 1
    end

    enemy_jumps = @board.grid[@row][col_to_check].made_moves

    case color
    when :white
      @moves_w_passant << [@row - 1, col_to_check] if valid_passant?(color, enemy_jumps, [@row, col_to_check])
    when :black
      @moves_w_passant << [@row + 1, col_to_check] if valid_passant?(color, enemy_jumps, [@row, col_to_check])
    end
  end

  def valid_passant?(color, jumps, square)
    current_turn = @board.turn
    enemy_last_turn = @board.grid[square.first][square.last].when_jumped[0]

    @ep_flag = current_turn - enemy_last_turn <= 1
    @board.grid[square.first][square.last].ep_flag = @ep_flag

    case color
    when :white
      jumps.size == 1 && jumps.first == [2, 0]
    when :black
      jumps.size == 1 && jumps.first == [-2, 0]
    end
  end

  def is_pawn?(position)
    return false if !(position[1] - 1).between?(0, 7) || !(position[1] + 1).between?(0, 7)

    @board.grid[position[0]][position[1]].piece == PIECES[:pawn]
  end
end
