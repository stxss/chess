require_relative("./../movement/directions")

class King
  include Directions

  attr_accessor :board

  def movement(board, start_position, piece)
    @board = board
    @start_position = start_position
    @piece = piece.piece
    @color = piece.color
    directions = [MOVE[:up], MOVE[:down], MOVE[:left], MOVE[:right], MOVE[:up_left], MOVE[:up_right], MOVE[:down_left],
      MOVE[:down_right]]

    piece.enemies = find_moves(:king, directions, :captures)

    piece.valid_moves = find_moves(:king, directions, :empty) + piece.enemies - checked_positions
  end

  def checked_positions
    arr = []
    @board.grid.each_with_index do |i, row|
      i.each_with_index do |piece, col|
        next if piece.color == @color

        @board.grid[row][col].valid_moves&.each do |move|
          arr << move if @board.grid[row][col].valid_moves.include?(move)
        end
      end
    end
    arr
  end
end
