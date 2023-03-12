module Movement
  def can_move?(previous, following)
    curr_piece = previous
    curr_color = @white.any?(curr_piece) ? "white" : "black"

    next_slot = @grid[following[0]][following[1]]
    next_color = if @white.any?(next_slot)
      "white"
    elsif @black.any?(next_slot)
      "black"
    else
      "empty"
    end
    @chosen = chosen_piece(curr_piece)
    # valid_move(@chosen, next_slot)
    # (curr_color != next_color || next_color == "empty") && following != @initial_pos && valid_move(@chosen, next_slot)

    (curr_color != next_color || next_color == "empty") && following != @initial_pos
  end

  def move(prev_pos, piece, following)
    @grid[following[0]][following[1]] = piece
    @grid[prev_pos[0]][prev_pos[1]] = EmptySquare.new.symbol
  end

  def chosen_piece(string)
    piece = string.scan(/[\u2654-\u265F]/)
    unicode_char = piece[0].ord # Translating the unicode piece back into a string
    unicode_escape = "\\u#{unicode_char.to_s(16)}"[5] # Retrieving the letter that identifies the chess piece

    case unicode_escape
    when "a"
      "king"
    when "b"
      "queen"
    when "c"
      "rook"
    when "d"
      "bishop"
    when "e"
      "knight"
    when "f"
      "pawn"
    end
  end

  module Vertical
    def go_up
    end

    def go_down
    end

    # go_up + #go_down
  end

  module Horizontal
    def go_left
    end

    def go_right
    end

    # go_left + go_right
  end

  module Diagonal
    def up_left
    end

    def up_right
    end

    def down_left
    end

    def down_right
    end

    # up_left + up_right + down_left + down_right
  end
end
