require_relative("piece")
require_relative("./../text_styles")

class King < Piece
  using TextStyles

  def white
    " \u{265A} ".fg_color(:white)
  end

  def black
    " \u{265A} ".fg_color(:black)
  end
end
