require_relative("./../movement/directions")

class Pawn
  include Directions

  def movement(board, start_position, piece)
    @board = board
    @start_position = start_position
    @piece = piece.piece
    @color = piece.color

    case @color
    when :white
      jump1, jump2 = MOVE[:up], [-2, 0]
      enemy_directions = [MOVE[:up_left], MOVE[:up_right]]
    when :black
      jump1, jump2 = MOVE[:down], [2, 0]
      enemy_directions = [MOVE[:down_left], MOVE[:down_right]]
    end

    directions = if !has_immediate_enemy?(@color) && moved_once?(@color)
      [jump1]
    elsif !has_immediate_enemy?(@color) && !moved_once?(@color)
      [jump1, jump2]
    else
      []
    end

    find_moves(:pawn, directions) + pawn_enemies(@color, enemy_directions)
  end

  private

  def moved_once?(color)
    # starting pawn rows, column is not relevant for this check
    w_pawn_start = 6
    b_pawn_start = 1

    case color
    when :white
      @start_position[0] != w_pawn_start
    when :black
      @start_position[0] != b_pawn_start
    end
  end

  def has_immediate_enemy?(color)
    row = @start_position[0]
    col = @start_position[1]

    case color
    when :white
      enemy?(color, [row - 1, col])
    when :black
      enemy?(color, [row + 1, col])
    end
  end

  def pawn_enemies(color, directions)
    row = @start_position[0]
    col = @start_position[1]
    enemies = []

    directions.each do |direction|
      next_row = row + direction[0]
      next_col = col + direction[1]

      unless next_col == 8
        enemies << [next_row, next_col] if enemy?(color, [next_row, next_col])
      end
    end
    enemies
  end
end
