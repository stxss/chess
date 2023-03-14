require_relative "./text_styles"

class Intro
  using TextStyles

  def initialize
    puts <<~HEREDOC
      #{"Welcome to Chess!".bold.italic.underlined}

      Chess is a board game between two players. It is played on a chessboard with 64 squares arranged in an eight-by-eight grid.

      At the start, each player controls sixteen pieces:

          - One king
          - One queen
          - Two rooks
          - Two bishops
          - Two knights
          - Eight pawns

      The player controlling the #{"white".bold.underlined} pieces moves first, followed by the player controlling the #{"black".bold.underlined} pieces.

      The object of the game is to #{"checkmate".bold.italic} the opponent's king, whereby the king is under immediate attack (in "check") and there is no way for it to escape. There are also several ways a game can end in a draw.
    HEREDOC
  end
end
