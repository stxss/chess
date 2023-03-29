module Movement
  def own_ep_check(piece, position, color)
    own_jumps = piece.made_moves
    own_last_turn = piece.when_jumped[0]

    @grid[position[0]][position[1]].ep_flag = (own_jumps&.first == ((color == :white) ? [-2, 0] : [2, 0])) && (@turn == own_last_turn)
  end

  def handle_ep(piece, previous, following)
    departure = NAMED_SQUARES[previous][0]
    destination = NAMED_SQUARES[following]
    pass = "#{departure}x#{destination}"

    case piece.color
    when :white
      if @grid[following.first + 1][following.last].ep_flag
        @grid[following.first + 1][following.last] = EmptySquare.new
        @pass_through = true
      end
    when :black
      if @grid[following.first - 1][following.last].ep_flag
        @grid[following.first - 1][following.last] = EmptySquare.new
        @pass_through = true
      end
    end
    annotate_moves(passant: pass)
    @grid[following.first][following.last] = piece
  end
end
