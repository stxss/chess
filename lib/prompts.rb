require_relative("text_styles")

class Prompts
  attr_reader :play_guide
  using TextStyles

  def play_guide_start
    <<~HEREDOC
      +-----------------------------
      - To #{"move around".bold.underlined.fg_color(:light_blue)} the board, you can use #{"WASD".fg_color(:light_blue)}, #{"\u{2191}\u{2193}\u{2190}\u{2192}".fg_color(:light_blue)} and, if you are a VIM enjoyer, you can also use your precious #{"HJKL".fg_color(:light_blue)} keys.

      - To #{"select".bold.underlined.fg_color(:light_green)} a piece, press #{"Enter".fg_color(:light_green)} or #{"e".fg_color(:light_green)}. You know you have a piece selected when the square is colored with #{"light green".fg_color(:light_green)}.

      - After selecting a piece, move to a square where you can place a piece (i.e, do a valid move) and press the selection key again.

      - If you selected a piece that has no valid moves or simply by mistake, press #{"Esc".fg_color(:pink)} on your keyboard to de-select the piece

      - When promoting a pawn, you must select between 4 options. Press the respective key to update the piece:

            #{"[1]".fg_color(:thistle)} Queen
            #{"[2]".fg_color(:thistle)} Rook
            #{"[3]".fg_color(:thistle)} Knight
            #{"[4]".fg_color(:thistle)} Bishop

      - If you want to castle, press #{"z".fg_color(:orange)} to castle queen-side or #{"x".fg_color(:orange)} to castle king-side

      - If you want to quit without saving your game, press #{"CTRL-C".fg_color(:dark_red)} or #{"q".fg_color(:dark_red)}.
      - If you want to quit and save your progress, press #{"g".fg_color(:dark_green)}.

      - That's pretty much it! Good luck!
    HEREDOC
  end

  def play_guide_in_game
    <<~HEREDOC
      +-----------------------------
      - #{"Movement".bold.underlined.fg_color(:light_blue)}: #{"WASD".fg_color(:light_blue)} | #{"\u{2191}\u{2193}\u{2190}\u{2192}".fg_color(:light_blue)} | #{"HJKL".fg_color(:light_blue)}

      - #{"Piece selection".bold.underlined.fg_color(:light_green)}: #{"[Enter]".fg_color(:light_green)} | #{"[e]".fg_color(:light_green)}

      - #{"Piece de-selection".bold.underlined.fg_color(:pink)}: #{"[Esc]".fg_color(:pink)}

      - #{"Pawn promotion".fg_color(:thistle)}: #{"[1]".fg_color(:thistle)} Queen | #{"[2]".fg_color(:thistle)} Rook | #{"[3]".fg_color(:thistle)} Knight | #{"[4]".fg_color(:thistle)} Bishop

      - #{"Castling".fg_color(:orange)}:  #{"[z]".fg_color(:orange)} Queen-side | #{"[x]".fg_color(:orange)} King-side

      - #{"Quit without saving".fg_color(:dark_red)}: #{"[CTRL-C]".fg_color(:dark_red)} | #{"[q]".fg_color(:dark_red)}

      - #{"Quit and save progress".fg_color(:dark_green)}: #{"[g]".fg_color(:dark_green)}
    HEREDOC
  end
end
