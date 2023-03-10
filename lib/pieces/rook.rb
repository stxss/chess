require_relative("piece")
require_relative("./../text_styles")

class Rook < Piece
  using TextStyles

  def white
    " \u{265C} ".fg_color(:white)
  end

  def black
    " \u{265C} ".fg_color(:black)
  end
end
