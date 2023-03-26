require_relative("serialize")
require_relative("text_styles")
require_relative("intro")
require_relative("prompts")
require_relative("constants")
require_relative("cursor")
require_relative("display")
require_relative("board")
require_relative("player")
require_relative("game")

def clear
  if RUBY_PLATFORM =~ /win32/ || RUBY_PLATFORM =~ /mingw/
    system("cls")
  else
    system("clear")
  end
end

def select_mode
  loop do
    user_input = gets.chomp
    unless user_input.match?(/[1-3]/)
      puts "Select an option between 1-3!"
    end

    clear if user_input.match?(/[1-3]/)
    case user_input
    when "1"
      play_computer
    when "2"
      play_human
    when "3"
      Dir.each_child("saved").each_with_index do |i, idx|
        puts "#{"[#{idx + 1}]".bold.fg_color(:light_blue)} #{i}"
      end

      filecount = Dir[File.join("saved", "**", "*")].count { |file| File.file?(file) }

      @chosen_file = ""
      all_files = Dir.entries("saved").select { |f| !File.directory? f }

      loop do
        @chosen_file = gets.chomp.to_i
        break if @chosen_file.between?(1, filecount)
      end

      selected_file = all_files[@chosen_file - 1]
      path = "saved/#{selected_file}"

      puts "saved/#{selected_file}"
      load_game(path)

      load_game
    end
  end
end

def play_computer
  puts "\n    vs a computer"
end

def play_human
  create_players
  create_board
  game = Game.new(player1: @players.first, player2: @players.last, board: @board)
  game.play
end

def load_game
  puts "\n  Select the number corresponding to the file to load the game from:\n\n"
end

def create_players
  @players = []

  if @players.first.nil? && @players.last.nil?
    name1 = give_name
    name2 = give_name(name1)
    @players << Player.new(name1)
    @players << Player.new(name2)
  else
    p1 = Player.new(p1_name)
    p2 = Player.new(p2_name)
    p1.score = p1_score.to_i
    p2.score = p2_score.to_i
    @players << p1
    @players << p2
  end
end

def give_name(prev_name = nil)
  loop do
    if !prev_name
      puts "\n    Please, enter a valid name for the first player: "
    else
      puts "\n    Please, enter a valid name for the second player: "
    end
    input = gets.chomp
    verified = verify_name(prev_name, input)
    return verified if verified
  end
end

def verify_name(prev_name, input)
  input if /^[a-zA-Z]+$/.match?(input) && input != prev_name
end

def create_board(players)
  @board = Board.new
  @board.create_scoreboard(players.first, players.last)
  @board.populate
  @board
end

Intro.new

select_mode
