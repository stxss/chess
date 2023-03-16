require_relative("./pieces/empty_square")
require_relative("text_styles")
require_relative("prompts")

class Display
  using TextStyles

  attr_accessor :board, :cursor

  def initialize(board, player1, player2)
    @board = board
    @player1 = player1
    @player2 = player2

    # Starting at [5, 4], to ease the navigation for the first play (with 1. e4 being the most common in chess)
    @cursor = Cursor.new([5, 4], board)
  end

  def show
    clear
    puts <<~HEREDOC

      #{@player1.name.rjust(22)} - #{@player1.score}

      #{display}

      #{@player2.name.rjust(22)} - #{@player2.score}


      #{Prompts.new.play_guide}
      #{@board.half_counter}
      #{@board.full_counter}
      #{@board.turn}
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
