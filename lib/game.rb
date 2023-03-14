class Game
  attr_accessor :board, :display
  def initialize
    play
  end

  private

  def play
    @board = Board.new
    @board.populate
    @display = Display.new(@board)

    loop do
      @display.show
      @display.cursor.ask_input
    end
  end
end
