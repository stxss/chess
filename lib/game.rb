class Game
  attr_accessor :board, :display, :is_winner, :draw, :player1, :player2
  def initialize(player1 = nil, player2 = nil, turn = 0)
    @player1 = player1
    @player2 = player2
    @turn = turn
    setup
    play
  end

  private

  def setup
    Intro.new
    create_players
    @board = Board.new
    @board.create_scoreboard(@player1, @player2)
    @board.populate
    @display = Display.new(@board, @player1, @player2)
  end

  def create_players
    if @player1.nil? && @player2.nil?
      name1 = create
      name2 = create(name1)
      @player1 = Player.new(name1)
      @player2 = Player.new(name2)
    end
  end

  def create(prev_name = nil)
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
    until has_winner? || draw?
      @display.show
      @display.cursor.ask_input
    end
    # update_score
    # @current_player = @turn.odd? ? @player1 : @player2
    # puts "Congratulations! #{@current_player.name} won the game!"
    if draw?
      puts "\nIt's a draw!"
    elsif has_winner?
      puts "\nThere's a winner!"
    end
    restart
  end

  private

  def verify_name(prev_name, input)
    input if /^[a-zA-Z]+$/.match?(input) && input != prev_name
  end

  # def update_score
  #   @current_player.score += 1
  #   @board.show_board
  # end

  def has_winner?
  end

  def draw?
    @board.half_counter >= 50
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
