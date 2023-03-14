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

    loop do
      @display.show
      @display.cursor.ask_input
      @turn += 1
    end
    # update_score
    # @current_player = @turn.odd? ? @player1 : @player2
    # puts "Congratulations! #{@current_player.name} won the game!"
    # restart
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
      puts "\nPlease, enter a valid name: "
      input = gets.chomp
      verified = verify_name(prev_name, input)
      return verified if verified
    end
  end

  def verify_name(prev_name, input)
    input if /^[a-zA-Z]+$/.match?(input) && input != prev_name
  end

  # def update_score
  #   @current_player.score += 1
  #   @board.show_board
  # end

    end
  end
end
