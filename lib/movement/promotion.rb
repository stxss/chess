module Movement
  def to_be_promoted(color, row)
    color == :white && row == 0 || color == :black && row == 7
  end

  def promote(color, following)
    @promo = true
    if @player2.name == "Computer" && color == :black
      annotate_moves(promotion: "#{NAMED_SQUARES[following]}=q")
      return Piece.new(:queen, color)
    end
    puts "Please select the piece you want to replace your pawn with:"
    until (piece = gets.chomp) =~ /[1-4]/
      puts "\nRemember that you must select a number from 1-4, as stipulated by the rules above.\nPlease select the piece you want to replace your pawn with:"
    end

    piece = case piece
    in "1" then :queen
    in "2" then :rook
    in "3" then :knight
    in "4" then :bishop
    end

    letter = case piece
    when :queen
      "q"
    when :rook
      "r"
    when :knight
      "n"
    when :bishop
      "b"
    end

    to_annotate = NAMED_SQUARES[following].to_s + "="
    to_annotate += (color == :white) ? letter.upcase : letter

    annotate_moves(promotion: to_annotate)
    Piece.new(piece, color)
  end
end
