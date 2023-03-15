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
      directions = moved_once?(@color) ? [[-1, 0]] : [[-1, 0], [-2, 0]]
      enemy_directions = [[-1, -1], [-1, 1]]
    when :black
      directions = moved_once?(@color) ? [[1, 0]] : [[1, 0], [2, 0]]
      enemy_directions = [[1, -1], [1, 1]]
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

  def pawn_enemies(color, directions)
    row = @start_position[0]
    col = @start_position[1]
    enemies = []

    directions.each do |direction|
      next_row = row + direction[0]
      next_col = col + direction[1]

      enemies << [next_row, next_col] if enemy?(color, [next_row, next_col])
    end
    enemies
  end
end
