class Game
  attr_accessor :board, :display
  def initialize
    play
  end

  private

  def play
    @board = Board.new
    @board.populate
    # grid = @board.grid

    @display = Display.new(@board)
    loop do
      @display.show
      @display.cursor.ask_input
    end
  end
end
