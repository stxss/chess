require_relative("piece")
require_relative("./../text_styles")

class Bishop < Piece
  using TextStyles

  def white
    " \u{265D} ".fg_color(:white)
  end

  def black
    " \u{265D} ".fg_color(:black)
  end
end
