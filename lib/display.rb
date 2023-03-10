require_relative "text_styles"

class Display
  using TextStyles

  attr_accessor :board, :moves

  def initialize(board)
    @board = board
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

    HEREDOC
  end

  def display
    output = ""
    @board.each_with_index do |i, row|
      output += " " * 9 + "#{(row - 8).abs.to_s.bold}" + " "
      i.each_with_index do |j, column|
        output += if (row + column).odd?
          j.bg_color(:red)
        else
          j.bg_color(:pink)
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
    output
  end

  def add_move
    output = ""

    @moves << output
  end
end
