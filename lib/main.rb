require_relative("text_styles")
require_relative("display")
require_relative("board")
require_relative("game")
require_relative("intro")
require_relative("player")
require_relative("prompts")

board = Board.new
p grid = board.grid
display = Display.new(grid)
board.populate
display.show
