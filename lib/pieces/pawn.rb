require_relative("./../text_styles")
require_relative("piece")

class Pawn < Piece
  using TextStyles

  def white
    " \u{265F} ".fg_color(:white)
  end

  def black
    " \u{265F} ".fg_color(:black)
  end
end
