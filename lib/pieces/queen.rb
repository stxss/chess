require_relative("piece")
require_relative("./../text_styles")

class Queen < Piece
  using TextStyles

  def white
    " \u{265B} ".fg_color(:white)
  end

  def black
    " \u{265B} ".fg_color(:black)
  end
end
