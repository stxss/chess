require("io/console")

class Cursor
  attr_accessor :cursor_pos, :selected, :board, :available_moves, :king_pos, :enemy_king_pos, :white_moves, :black_moves, :piece, :check, :king_options, :checkmate

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
        set_king_pos(@piece.color)
        set_selected
      elsif @selected && @board.can_move?(@cursor_pos, @available_moves)
        @board.move(@initial_pos, @piece, @cursor_pos)
        reset_relevant
        update_all_moves
        is_check?(@piece)
        is_checkmate?(@enemy_king_pos)
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

  def update_all_moves
    @white_moves = all_moves(:white)
    @black_moves = all_moves(:black)
  end

  def is_check?(piece)
    @check = piece.enemies.include?(@enemy_king_pos)
  end

  def is_checkmate?(king_square)
    return unless @check

    @king_options = @board.grid[king_square[0]][king_square[1]].valid_moves
    @checkmate = !sets_king_free?(@king_options) # need to add all other moves
  end

  private

  def sets_king_free?(moves)
    possibilities = []
    row = @enemy_king_pos[0]
    col = @enemy_king_pos[1]
    king = @board.grid[@enemy_king_pos[0]][@enemy_king_pos[1]]
    moves.each do |move|
      @board.move([row, col], king, move)
      possibilities << is_check?(@board.grid[move[0]][move[1]])
      @board.move(move, king, [row, col])
    end
    possibilities.any?(true)
  end

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

  def set_king_pos(color)
    @king_pos = find_king(color)
    @enemy_king_pos = (color == :white) ? find_king(:black) : find_king(:white)
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
