module Directions
  def find_moves(piece, directions)
    row = @start_position[0]
    col = @start_position[1]
    enemies = []
    empties = []

    directions.each do |direction|
      next_row = row + direction[0]
      next_col = col + direction[1]

      while next_row.between?(0, 7) && next_col.between?(0, 7)
        if ally?(@color, [next_row, next_col])
          break
        elsif enemy?(@color, [next_row, next_col])
          enemies << [next_row, next_col]
          break
        elsif empty?([next_row, next_col])
          empties << [next_row, next_col]
        end

        case piece
        when :pawn, :knight, :king
          break
        end
        next_row += direction[0]
        next_col += direction[1]
      end
    end
    empties + enemies
  end

  def enemy?(color, square)
    @board.grid[square[0]][square[1]].color != color && !empty?(square)
  end

  def ally?(color, square)
    @board.grid[square[0]][square[1]].color == color && !empty?(square)
  end

  def empty?(square)
    @board.grid[square[0]][square[1]].instance_of?(EmptySquare)
  end
end
