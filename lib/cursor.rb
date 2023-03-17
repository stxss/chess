require("io/console")

KEYS = {
  "w"      => :up,
  "s"      => :down,
  "a"      => :left,
  "d"      => :right,
  "k"      => :up,
  "j"      => :down,
  "h"      => :left,
  "l"      => :right,
  "\e[A"   => :up,
  "\e[B"   => :down,
  "\e[D"   => :left,
  "\e[C"   => :right,
  "e"      => :return,
  "\r"     => :return,
  "q"      => :ctrl_c,
  "\e"     => :escape,
  "g"      => :save,
  "\177"   => :backspace,
  "\004"   => :delete,
  "\t"     => :tab,
  "\n"     => :newline,
  "\u0003" => :ctrl_c
}.freeze

MOVE = {
  up:    [-1, 0],
  down:  [1, 0],
  left:  [0, -1],
  right: [0, 1]
}.freeze

class Cursor
  attr_accessor :cursor_pos, :selected, :board, :available_moves

  def initialize(cursor_pos, board)
    @cursor_pos = cursor_pos
    @board = board
    @selected = false
  end

  def ask_input
    key = KEYS[ask_key]
    interpret(key)
  end

  private

  # very valuable info from https://www.alecjacobson.com/weblog/?p=75 and https://gist.github.com/acook/4190379

  def ask_key
    $stdin.echo = false # because the keys are not to be shown in CLI when playing
    $stdin.raw! # because the user should be able to navigate CLI without having to press enter
    input = $stdin.getc.chr

    if input == "\e"
      begin
        input << $stdin.read_nonblock(3)
      rescue
        nil
      end

      begin
        input << $stdin.read_nonblock(2)
      rescue
        nil
      end
    end

    $stdin.echo = true
    $stdin.cooked! # return to the normal input mode, reverse of raw!, as using only raw can "break" the CLI

    input
  end

  def interpret(key)
    case key
    when :up, :down, :left, :right
      update_cursor(MOVE[key])
    when :return
      if !@selected
        @selected = has_piece?(@cursor_pos) && correct_turn?
        @initial_pos = @cursor_pos
        @piece = select_piece(@initial_pos)
        @available_moves = @board.possible_moves(@board, @cursor_pos, @piece)
      elsif @selected && @board.can_move?(@initial_pos, @cursor_pos, @available_moves)
        @board.move(@initial_pos, @piece, @cursor_pos)
        reset_relevant
      end
    when :escape
      @selected = false if @selected
      @available_moves = nil
    when :ctrl_c
      puts "\nThank you for playing Chess! See you next time :D"
      exit
    when :save
      puts "\nYour game was saved as {}. Do you want to create a new game? [Y/n]"
      exit
    end
  end

  def update_cursor(move)
    new_pos = [@cursor_pos[0] + move[0], @cursor_pos[1] + move[1]]
    @cursor_pos = new_pos if @board.in_range?(new_pos)
  end

  def has_piece?(cell)
    cell = @board.grid[cell[0]][cell[1]]
    cell.symbol != "   "
  end

  def correct_turn?
    counter = @board.turn
    color_turn = counter.even? ? :white : :black
    @board.grid[@cursor_pos[0]][@cursor_pos[1]].color == color_turn
  end

  def select_piece(position)
    @board.grid[position[0]][position[1]]
  end

  def reset_relevant
    @available_moves = nil
    @selected = false
  end
end
