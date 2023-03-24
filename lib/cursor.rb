require("io/console")

class Cursor
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
        set_initial
        set_playing_piece
        set_valid_moves
        set_selected
      elsif @selected && @board.can_move?(@current_pos, @valid_moves)
        move_piece
        update_movement
        reset_relevant
        @board.checks?
        mate_or_stale?(@piece.color, :stale)
        mate_or_stale?(@piece.color, :mate)
      end
    when :king_side
      @board.castle_handler(current_color, :king, @board.white_moves, @board.black_moves)
    when :queen_side
      @board.castle_handler(current_color, :queen, @board.white_moves, @board.black_moves)
    when :escape
      @selected = false if @selected
      @valid_moves = nil
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
    new_pos = [@current_pos.first + move.first, @current_pos.last + move.last]
    @current_pos = new_pos if @board.in_range?(new_pos)
  end

  def set_initial
    @initial_pos = @piece.position
  end

  def set_playing_piece
    @piece = select_piece(@current_pos)
  end

  def select_piece(position)
    @board.grid[position.first][position.last]
  end

  def set_valid_moves
    @valid_moves = @board.possible_moves(@board, @current_pos,
      @piece)&.intersection(safe_from_check?(@board, @initial_pos, @piece))
  end

  def safe_from_check?(game, initial, piece)
    ghost_board = Board.new.copy(game)

    ghost_piece = ghost_board.grid[initial.first][initial.last]

    safe = []

    ghost_piece&.valid_moves&.each do |move|
      ghost_board.move(initial, ghost_piece, move, :ghost)
      ghost_board.update_all_moves(ghost_board)

      safe << move if !ghost_board.in_check?(ghost_board.white_moves, ghost_board.black_moves, ghost_board.white_king,
        ghost_board.black_king, ghost_piece.color)

      ghost_board.move(move, ghost_piece, initial, :ghost)
      ghost_board.update_all_moves(ghost_board)
    end
    safe
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

  def update_movement
    @board.update_all_moves(@board)
  end

  def reset_relevant
    @valid_moves = nil
    @selected = false
  end

  def mate_or_stale?(color, verification)
    case verification
    when :mate
      target_color = (color == :white?) ? :black : :white
    when :stale
      target_color = (color == :white?) ? :white : :black
    end

    @safe_moves = []
    @board.grid.each_with_index do |i, row|
      i.each_with_index do |piece, col|
        next if piece.color != target_color

        piece.valid_moves.each do |move|
          @safe_moves += safe_from_check?(@board, [row, col], piece)
        end
      end
    end
    case verification
    when :mate
      @board.checkmate = @safe_moves.uniq.flatten.empty? && @board.check
    when :stale
      @board.stalemate = @safe_moves.uniq.flatten.empty? && !@board.check
    end
  end
end
