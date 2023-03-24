module Movement
  def to_be_promoted(color, row)
    color == :white && row == 0 || color == :black && row == 7
  end

  def promote(color)
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

    Piece.new(piece, color)
  end
end
