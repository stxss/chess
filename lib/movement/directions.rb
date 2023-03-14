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

  module Horizontal
    def horizontal
      left + right
    end

    def left
      moves = []

      @board.grid.select.with_index do |row, i|
        row.select.with_index do |col, j|
          if i == @start_position[0] && j < @start_position[1]
            moves << col.piece
          end
        end
      end
      moves
    end

    def right
      moves = []

      @board.grid.select.with_index do |row, i|
        row.select.with_index do |col, j|
          if i == @start_position[0] && j > @start_position[1]
            moves << col.piece
          end
        end
      end
      moves
    end

    # left + right
  end

  module Diagonal
    # not sure if this is necessary, as diagonal == (horizontal + vertical)
    def up_left
      moves = []

      @board.grid.select.with_index do |row, i|
        row.select.with_index do |col, j|
          if i < @start_position[0] && j < @start_position[1]
            moves << col.piece
          end
        end
      end
      moves
    end

    def up_right
      moves = []

      @board.grid.select.with_index do |row, i|
        row.select.with_index do |col, j|
          if i < @start_position[0] && j < @start_position[1]
            moves << col.piece
          end
        end
      end
      moves
    end

    def down_left
      moves = []

      @board.grid.select.with_index do |row, i|
        row.select.with_index do |col, j|
          if i < @start_position[0] && j < @start_position[1]
            moves << col.piece
          end
        end
      end
      moves
    end

    def down_right
      moves = []

      @board.grid.select.with_index do |row, i|
        row.select.with_index do |col, j|
          if i < @start_position[0] && j < @start_position[1]
            moves << col.piece
          end
        end
      end
      moves
    end

    # up_left + up_right + down_left + down_right
  end
end
