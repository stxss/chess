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
      @current_prompt = Prompts.new.game_end(player)
      @game_instructions = Prompts.new.empty
    end
  end

  private

  def display
    output = ""
    @board.grid.each_with_index do |i, row|
      output += " " * 9 + (row - 8).abs.to_s.bold.to_s + " "
      i.each_with_index do |piece, column|
        to_display = piece.painted

        if valid_move(row, column) && @board.empty?([row, column], board: board)
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
      output += "\n"
    end
    output += "            a  b  c  d  e  f  g  h".bold
  end

  def cursor_selected?(row, column)
    @cursor.current_pos == [row, column] && @cursor.selected
  end

  def cursor_deselected?(row, column)
    @cursor.current_pos == [row, column] && !@cursor.selected
  end

  def valid_move(row, column)
    @cursor.available_moves&.any?([row, column])
  end

  def paint(square, color)
    square.bg_color(color)
  end

  def moves
    output = []
    jumps = @board.translated_jumps
    jumps.each_with_index do |jump, index|
      memo = jump[1]
      piece = memo[0] unless memo[0] == "p" || memo[0] == "P"
      where_to = NAMED_SQUARES[memo[3]]
      capture = "x" if memo[2]
      if capture == "x" && (memo[0] == "p" || memo[0] == "P")
        from_where = NAMED_SQUARES[memo[1]][0]
      end
      check = "+" if memo[0][4] && !memo[0][5]
      checkmate = "#" if memo[0][5]
      stalemate = "1/2-1/2" if memo[0][6]
      output << "#{from_where}#{piece}#{capture}#{where_to}#{check}#{checkmate}#{stalemate}"
    end
    print_moves(output)
  end

  def print_moves(moveset)
    row = 3
    col = 40
    new_arr = []

    moveset.each_slice(2) do |white, black|
      new_arr << [white, black]
    end

    final_print = []
    new_arr.each_with_index do |move, idx|
      final_print << [(idx + 1).to_s, "tput cup #{row} #{col}", move.first, move.last]

      row += 1
      if row == 12
        col += 15
        row = 3
      end
    end

    if @board.check && !@board.checkmate && final_print.last[3]
      final_print.last[3] += "+"
    elsif @board.check && !@board.checkmate && final_print.first[3]
      final_print.first[3] += "+"
    end
    # final_print.last[3] += "+"
    final_print.last[3] += "#" if @board.checkmate
    final_print.last[3] += "1/2-1/2" if @board.stalemate


    final_print.each do |el|
      system(el[1])
      puts "#{el[0]}. #{el[2]} #{el[3]}"
      # puts final_print

      system("tput cup 0 0")
      print ""
    end

    if @board.checkmate || @board.stalemate
      system("tput cup 15 0")
      puts "\n"
    else
      system("tput cup 30 0")
    end
    # print "" # end on this as the line above returns true to the display
    # puts "" # end on this as the line above returns true to the display
    new_arr.join(" ")
  end
end
