class Game
  attr_accessor :board, :display, :player1, :player2, :color

  def initialize(player1 = nil, player2 = nil)
    @player1 = player1
    @player2 = player2
    # Intro.new
  end

  def setup
    create_players
    create_board
    create_cursor
    create_display
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

  def play
    until game_ended?
      set_players
      set_prompts(@current.name, @other.name)
      set_display
      set_color

      if @display.cursor.checkmate
        update_score
        restart
      end
    end

    end_game_handler(@current.name, @other.name)
  end

  def end_game_handler(current, other)
    if draw?
      @display.change_prompt(@color, current, :draw)
    elsif stalemate?
      @display.change_prompt(@color, current, :stalemate)
    end
    @display.show
    restart
  end

  private

  def create_players
    if @player1.nil? && @player2.nil?
      name1 = give_name
      name2 = give_name(name1)
      @player1 = Player.new(name1)
      @player2 = Player.new(name2)
    end
  end

  def create_board
    @board = Board.new
    @board.create_scoreboard(@player1, @player2)
    @board.populate
  end

  def create_cursor
    @cursor = Cursor.new([5, 4], @board)
  end

  def create_display
    @display = Display.new(@board, @player1, @player2)
  end

  def set_color
    @color = @board.turn.odd? ? "black" : "white"
  end

  def set_display
    @display.show
    @display.cursor.ask_input
  end

  def set_players
    @current = @board.turn.odd? ? @player1 : @player2
    @other = @board.turn.odd? ? @player2 : @player1
  end

  def set_prompts(current, other)
    @display.change_prompt(@color, other, :to_move)
    @display.change_prompt(@color, other, :check) if @board.check
  end

  def game_ended?
    draw? || stalemate?
  end

  def verify_name(prev_name, input)
    input if /^[a-zA-Z]+$/.match?(input) && input != prev_name
  end

  def update_score
    @other.score += 1
    @display.change_prompt(@color, @other.name, :game_end)
    @display.show
  end

  def draw?
    @board.half_counter >= 50
  end

  def stalemate?
    @display.cursor.stalemate
  end

  def restart
    loop do
      puts "\nDo you want to play again? Please enter a valid option. [Y/N]"
      answer = gets.chomp
      case answer
      when "Y", "y", "yes".downcase
        new_game = Game.new(@player1, @player2)
        new_game.play
      when "N", "n", "no".downcase
        puts "Thank you for playing Chess!"
        exit
      end
    end
  end
end
