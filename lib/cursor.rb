require("io/console")
require_relative("./fen")

class Cursor
  include Fen
  attr_accessor :current_pos, :selected, :board, :available_moves, :piece

  def initialize(current_pos, board)
    @current_pos = current_pos
    @board = board
    @selected = false
  end

  def ask_input
    key = KEYS[ask_key]
    interpret(key)
  end

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
        set_playing_piece
        set_initial
        set_movement
        set_selected
      elsif @selected && @board.can_move?(@current_pos, @available_moves)
        move_piece
        reset_relevant
        @board.check?
        @board.mate_or_stale?(@piece.color)
      end
    when :king_side
      @board.castle_handler(current_color, :king)
    when :queen_side
      @board.castle_handler(current_color, :queen)
    when :escape
      @selected = false if @selected
      @available_moves = nil
    when :ctrl_c
      puts "\nThank you for playing Chess! See you next time :D"
      exit
    when :save
      fen_str = to_fen
      puts "\nYour game was saved as {}. Do you want to create a new game? [Y/n]"
      puts fen_str
      exit
    end
  end

  private

  def update_cursor(move)
    new_pos = [@current_pos.first + move.first, @current_pos.last + move.last]
    @current_pos = new_pos if @board.in_range?(new_pos)
  end

  def set_playing_piece
    @piece = @board.grid[@current_pos.first][@current_pos.last]
  end

  def set_initial
    @initial_pos = @piece.position
  end

  def set_movement
    @available_moves = @board.valid_movements(@piece, @initial_pos, @current_pos)
  end

  def set_selected
    @selected = has_piece?(@current_pos) && correct_turn?
  end

  def has_piece?(cell)
    cell = @board.grid[cell.first][cell.last]
    cell.painted != "   "
  end

  def correct_turn?
    @board.grid[@current_pos.first][@current_pos.last].color == current_color
  end

  def current_color
    @board.turn.even? ? :white : :black
  end

  def move_piece
    @board.move(@initial_pos, @piece, @current_pos, :actual)
  end

  def reset_relevant
    @available_moves = nil
    @selected = false
  end
end
