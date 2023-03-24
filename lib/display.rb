require_relative("./pieces/empty_square")
require_relative("text_styles")
require_relative("prompts")

class Display
  using TextStyles

  attr_accessor :board, :cursor, :player1, :player2, :game_instructions, :current_prompt

  def initialize(board, player1, player2)
    @board = board
    @player1 = player1
    @player2 = player2

    # Starting at [5, 4], to ease the navigation for the first play (with 1. e4 being the most common in chess)
    @cursor = Cursor.new([5, 4], board)
    @game_instructions = Prompts.new.play_guide_in_game
    @current_prompt = Prompts.new.empty
  end

  def show
    clear
    puts <<~HEREDOC

      #{@player2.name.rjust(22)} - #{@player2.score}

      #{display}

      #{@player1.name.rjust(22)} - #{@player1.score}
      #{moves}

      #{@current_prompt}
      #{@game_instructions}
    HEREDOC
    # pp @board
  end

  def change_prompt(color, player, status)
    case status
    when :to_move
      @current_prompt = Prompts.new.to_move(player)
    when :check
      @current_prompt = Prompts.new.check(color, player)
    when :stalemate
      @game_instructions = Prompts.new.empty
      @current_prompt = Prompts.new.stalemate
    when :draw
      @game_instructions = Prompts.new.empty
      @current_prompt = Prompts.new.draw
    when :game_end
      @game_instructions = Prompts.new.empty
      @current_prompt = Prompts.new.game_end(player)
    end
  end

  private

  def display
    output = ""
    @board.grid.each_with_index do |i, row|
      output += " " * 9 + (row - 8).abs.to_s.bold.to_s + " "
      i.each_with_index do |piece, column|
        to_display = piece.painted

        if valid_move(row, column) && @board.is_empty?([row, column])
          to_display = " \u{25cb} ".fg_color(:dark_green) # Circle symbol
        end

        square_color = if cursor_deselected?(row, column)
          :light_blue
        elsif cursor_selected?(row, column)
          :light_green
        elsif (row + column).odd?
          :red
        else
          :pink
        end

        bg_color = paint(to_display, square_color)
        output += bg_color
      end
      # moves
      output += "\n"
    end
    output += "            a  b  c  d  e  f  g  h".bold
  end

  def clear
    if RUBY_PLATFORM =~ /win32/ || RUBY_PLATFORM =~ /mingw/
      system("cls")
    else
      system("clear")
    end
  end

  def cursor_selected?(row, column)
    @cursor.current_pos == [row, column] && @cursor.selected
  end

  def cursor_deselected?(row, column)
    @cursor.current_pos == [row, column] && !@cursor.selected
  end

  def valid_move(row, column)
    @cursor.valid_moves&.any?([row, column])
  end

  def paint(square, color)
    square.bg_color(color)
  end

  def moves
    system("tput cup 3 40")
    puts "1. e4 e2 "
    system("tput cup 4 40")
    puts "2. e3 e1"
    system("tput cup 5 40")
    puts "3. d6 h5"
    system("tput cup 0 0")
  end
end
