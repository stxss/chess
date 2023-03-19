module Directions
  def find_moves(piece, directions, goal)
    row = @start_position[0]
    col = @start_position[1]
    enemies = []
    empties = []

    directions.each do |direction|
      next_row = row + direction[0]
      next_col = col + direction[1]

      while @board.in_range?([next_row, next_col])
        if ally?(@color, [next_row, next_col])
          break
        elsif enemy?(@color, [next_row, next_col])
          enemies << [next_row, next_col]
          break
        elsif empty?([next_row, next_col])
          empties << [next_row, next_col]
        end

        break if piece == :pawn || piece == :king || piece == :knight

        next_row += direction[0]
        next_col += direction[1]
      end
    end

    case goal
    when :captures
      enemies
    when :empty
      empties
    end
  end

  def enemy?(color, square)
    return if @board.grid[square[0]][square[1]].nil?

    @board.grid[square[0]][square[1]].color != color && !empty?(square)
  end

  def ally?(color, square)
    @board.grid[square[0]][square[1]].color == color && !empty?(square)
  end

  def empty?(square)
    @board.grid[square[0]][square[1]].instance_of?(EmptySquare)
  end
end
