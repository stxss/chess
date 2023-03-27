class Game
  attr_accessor :board, :display, :player1, :player2, :color

  def initialize(player1: nil, player2: nil, board: Board.new)
    @player1 = player1
    @player2 = player2
    @board = board
    @cursor = create_cursor
    @display = create_display
  end

  def play
    until game_ended?
      set_players
      set_prompts(@current.name, @other.name)
      set_display
      set_color

      if @board.checkmate
        update_score
        restart
      end
    end

    end_game_handler(@current.name, @other.name)
  end

  private

  def create_cursor
    Cursor.new([5, 4], @board)
  end

  def create_display
    Display.new(@board, @player1, @player2)
  end

  def set_color
    @color = @board.turn.odd? ? "black" : "white"
  end

  def set_display
    @display.show
    if @player2.name == "Computer" && @color == "black"
      return @display.cursor.interpret(:ai)
    end
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
    fifty_moves? || stalemate? || saved?
  end

  def verify_name(prev_name, input)
    input if /^[a-zA-Z]+$/.match?(input) && input != prev_name
  end

  def update_score
    @other.score += 1
    @display.change_prompt(@color, @other.name, :game_end)
    @display.show
  end

  def fifty_moves?
    @board.half_counter.to_i >= 50
  end

  def stalemate?
    @board.stalemate
  end

  def saved?
    @board.saved
  end

  def end_game_handler(current, other)
    if fifty_moves?
      @display.change_prompt(@color, current, :draw)
    elsif stalemate?
      @display.change_prompt(@color, current, :stalemate)
    end
    @display.show
    restart
  end

  def restart
    if saved?
      puts "\nYour game was saved as '#{@board.filename}'"
    end

    loop do
      puts "\nDo you want to play again? Please enter a valid option. [Y/N]"
      answer = gets.chomp
      case answer
      when "Y", "y", "yes".downcase
        new_board = create_board([@player1, @player2])
        new_game = Game.new(player1: @player1, player2: @player2, board: new_board)
        new_game.play
      when "N", "n", "no".downcase
        puts "Thank you for playing Chess!"
        exit
      end
    end
  end
end
