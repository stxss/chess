require_relative("piece")
require_relative("./../text_styles")

class Knight < Piece
  using TextStyles

  def white
    " \u{265E} ".fg_color(:white)
  end

  def black
    " \u{265E} ".fg_color(:black)
  end
end
