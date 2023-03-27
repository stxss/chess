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

using TextStyles

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
      play(:computer)
    when "2"
      play(:human)
    when "3"
      puts "\n  Select the number corresponding to the file to load the game from:\n\n"
      Dir.each_child("saved").each_with_index do |file, idx|
        puts "    #{"[#{idx + 1}]".bold.fg_color(:light_blue)} #{file}"
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
      load_game(path)
    end
  end
end

def play(opponent)
  case opponent
  when :human
    create_players
  when :computer
    create_players(p2_name: "Computer")
  end
  create_board(@players)
  game = Game.new(player1: @players.first, player2: @players.last, board: @board)
  game.play
end

def load_game(path)
  game_info = File.read(path)
  from_data(game_info)
end

def from_data(data)
  info = data.split
  fen_string = "#{info[0]} #{info[1]} #{info[2]} #{info[3]} #{info[4]} #{info[5]}"
  create_players(p1_name: info[6], p1_score: info[7], p2_name: info[8], p2_score: info[9])

  saved_game = Board.new(fen_string)
  saved_game.create_scoreboard(@players.first, @players.last)

  game = Game.new(player1: @players.first, player2: @players.last, board: saved_game)
  game.board.update_positions
  game.board.update_all_moves(saved_game)
  game.board.turn = set_turn(info[1], info[5].to_i)

  key = set_ep_flag(game, info[3])
  if key[0] == 5
    game.board.grid[key[0] - 1][key[1]].ep_flag = true
  elsif key[0] == 2
    game.board.grid[key[0] + 1][key[1]].ep_flag = true
  end

  game.play
end

def set_ep_flag(game, flag)
  return [] if flag == "-"

  NAMED_SQUARES.key(flag)
end

def set_turn(color, full_count)
  case color
  when "w"
    full_count * 2
  when "b"
    full_count * 2 - 1
  end
end

def create_players(p1_name: nil, p1_score: nil, p2_name: nil, p2_score: nil)
  @players = []

  @players << (Player.new(p1_name || give_name))
  @players << (Player.new(p2_name || give_name(p1_name)))

  @players.first.score = p1_score.to_i
  @players.last.score = p2_score.to_i
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
  @board.update_all_moves(@board)
  @board
end

Intro.new

select_mode
