require_relative("text_styles")
require_relative("intro")
require_relative("prompts")
require_relative("constants")
require_relative("cursor")
require_relative("display")
require_relative("board")
require_relative("player")
require_relative("game")
require_relative("./movement/movement")

def create_players
  @players = []

  if @players.first.nil? && @players.last.nil?
    name1 = give_name
    name2 = give_name(name1)
    @players << Player.new(name1)
    @players << Player.new(name2)
  end
end

def give_name(prev_name = nil)
  loop do
    if !prev_name
      puts "\nPlease, enter a valid name for the first player: "
    else
      puts "\nPlease, enter a valid name for the second player: "
    end
    input = gets.chomp
    verified = verify_name(prev_name, input)
    return verified if verified
  end
end

def verify_name(prev_name, input)
  input if /^[a-zA-Z]+$/.match?(input) && input != prev_name
end

def create_board
  @board = Board.new
  @board.create_scoreboard(@players.first, @players.last)
  @board.populate
end

Intro.new

create_players
create_board

game = Game.new(player1: @players.first, player2: @players.last, board: @board)

game.play
