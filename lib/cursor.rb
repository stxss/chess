require("io/console")

class Cursor
  attr_accessor :cursor_pos, :selected, :board, :available_moves, :enemy_king, :white_moves, :black_moves,
    :piece, :check, :checkmate, :king_valid_moves, :white_king, :black_king

  def initialize(cursor_pos, board)
    @cursor_pos = cursor_pos
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
        set_initial
        set_piece
        set_available_moves
        set_king_pos
        set_selected
      elsif @selected && @board.can_move?(@cursor_pos, @available_moves)
        @board.move(@initial_pos, @piece, @cursor_pos)
        update_all_moves
        reset_relevant
        is_check?
        is_checkmate?
      end
    when :king_side
      color = @current_player = @board.turn.odd? ? :black : :white
      @board.castle_handler(color, :king, @check, @white_moves, @black_moves)
    when :queen_side
      color = @current_player = @board.turn.odd? ? :black : :white
      @board.castle_handler(color, :queen, @check, @white_moves, @black_moves)
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

  private

  def update_cursor(move)
    new_pos = [@cursor_pos.first + move.first, @cursor_pos.last + move.last]
    @cursor_pos = new_pos if @board.in_range?(new_pos)
  end

  def set_initial
    @initial_pos = @cursor_pos
  end

  def set_piece
    @piece = select_piece(@initial_pos)
  end

  def set_available_moves
    @available_moves = @board.possible_moves(@board, @cursor_pos, @piece)
  end

  def set_king_pos
    @white_king = find_king(:white)
    @black_king = find_king(:black)
  end

  def set_selected
    @selected = has_piece?(@cursor_pos) && correct_turn?
  end

  def has_piece?(cell)
    cell = @board.grid[cell.first][cell.last]
    cell.symbol != "   "
  end

  def correct_turn?
    counter = @board.turn
    color_turn = counter.even? ? :white : :black
    @board.grid[@cursor_pos.first][@cursor_pos.last].color == color_turn
  end

  def select_piece(position)
    @board.grid[position.first][position.last]
  end

  def update_all_moves
    @white_moves = all_moves(:white)
    @black_moves = all_moves(:black)
  end

  def is_check?
    @check = @white_moves.include?(@black_king) || @black_moves.include?(@white_king)

    @enemy_king = (@piece.color == :white) ? @black_king : @white_king

    @board.grid[@enemy_king[0]][@enemy_king[1]].valid_moves -= @piece.valid_moves
  end

  def is_checkmate?
    return unless @check

    @checkmate = @board.grid[@enemy_king[0]][@enemy_king[1]].valid_moves.size < 1
  end

  def reset_relevant
    @available_moves = nil
    @selected = false
  end

  def find_king(color)
    @board.grid.each_with_index do |i, row|
      i.each_with_index do |piece, column|
        character = piece.piece
        return [row, column] if character == PIECES[:king] && piece.color == color
      end
    end
  end

  def all_moves(color)
    arr = []
    @board.grid.each_with_index do |i, row|
      i.each_with_index do |piece, column|
        arr += @board.possible_moves(@board, [row, column], piece) if piece.color == color
      end
    end
    arr
  end
end
