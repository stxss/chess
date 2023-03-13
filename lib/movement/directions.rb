module Directions
  module Vertical
    def vertical
      up + down
    end

    def up
      moves = []

      @board.grid.select.with_index do |row, i|
        row.select.with_index do |col, j|
          moves << "self" if @start_position == [i, j]
          if j == @start_position[1] && i < @start_position[0]
            moves << col.piece
          end
        end
      end
      moves
    end

    def down
      moves = []

      @board.grid.select.with_index do |row, i|
        row.select.with_index do |col, j|
          if j == @start_position[1] && i > @start_position[0]

            moves << col.piece
          end
        end
      end
      moves
    end
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
