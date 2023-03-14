require_relative("./pieces/empty_square")
require_relative "text_styles"

class Display
  using TextStyles

  attr_accessor :board, :moves, :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([5, 4], board) # Starting at [5, 4], to ease the navigation for the first play (with 1. e4 being the most common in chess)
    @moves = []
    add_move
    show
  end

  def show
    if RUBY_PLATFORM =~ /win32/ || RUBY_PLATFORM =~ /mingw/
      system("cls")
    else
      system("clear")
    end

    puts <<~HEREDOC

                    player1 - score

      #{display}

                    player2 - score

      +-----------------------------
      - To #{"move around".bold.underlined.fg_color(:light_blue)} the board, you can use #{"WASD".fg_color(:light_blue)}, #{"\u{2191}\u{2193}\u{2190}\u{2192}".fg_color(:light_blue)} and, if you are a VIM enjoyer, you can also use your precious #{"HJKL".fg_color(:light_blue)} keys.

      - To #{"select".bold.underlined.fg_color(:light_green)} a piece, press #{"Enter".fg_color(:light_green)} or #{"e".fg_color(:light_green)}. You know you have a piece selected when the square is colored with #{"light green".fg_color(:light_green)}.

      - After selecting a piece, move to a square where you can place a piece (i.e, do a valid move) and press the selection key again.

      - If you want to quit without saving your game, press #{"CTRL-C".fg_color(:dark_red)} or #{"q".fg_color(:dark_red)}.
      - If you want to quit and save your progress, press #{"g".fg_color(:dark_green)}.

      - That's pretty much it! Good luck!
    HEREDOC
  end

  private

  def display
    output = ""
    @board.grid.each_with_index do |i, row|
      output += " " * 9 + (row - 8).abs.to_s.bold.to_s + " "
      i.each_with_index do |piece, column|
        to_display = piece.symbol

        if @cursor.available_moves&.any?([row, column]) && @board.grid[row][column].instance_of?(EmptySquare)
          to_display = " \u{25cb} ".fg_color(:dark_green)
        end

        output += if @cursor.cursor_pos == [row, column] && !@cursor.selected
          to_display.bg_color(:light_blue)
        elsif @cursor.cursor_pos == [row, column] && @cursor.selected
          to_display.bg_color(:light_green)
        elsif (row + column).odd?
          to_display.bg_color(:red)
        else
          to_display.bg_color(:pink)
        end
      end
      # system("tput cup 3 40")
      # puts "1. e4 e2 "
      # system("tput cup 4 40")
      # puts "2. e3 e1"
      # system("tput cup 5 40")
      # puts "3. d6 h5"
      # system("tput cup 0 0")
      output += "\n"
    end
    output += "            a  b  c  d  e  f  g  h".bold
  end

  def add_move
    output = ""

    @moves << output
  end
end
