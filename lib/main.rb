require_relative("board")
require_relative("display")
require_relative("game")
require_relative("intro")
require_relative("player")
require_relative("prompts")

p board = Board.new.grid
display = Display.new(board)
