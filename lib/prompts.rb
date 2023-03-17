require_relative("text_styles")

class Prompts
  attr_reader :play_guide
  using TextStyles

  def play_guide
    <<~HEREDOC
      +-----------------------------
      - To #{"move around".bold.underlined.fg_color(:light_blue)} the board, you can use #{"WASD".fg_color(:light_blue)}, #{"\u{2191}\u{2193}\u{2190}\u{2192}".fg_color(:light_blue)} and, if you are a VIM enjoyer, you can also use your precious #{"HJKL".fg_color(:light_blue)} keys.

      - To #{"select".bold.underlined.fg_color(:light_green)} a piece, press #{"Enter".fg_color(:light_green)} or #{"e".fg_color(:light_green)}. You know you have a piece selected when the square is colored with #{"light green".fg_color(:light_green)}.

      - After selecting a piece, move to a square where you can place a piece (i.e, do a valid move) and press the selection key again.

      - If you selected a piece that has no valid moves or simply by mistake, press #{"Esc".fg_color(:pink)} on your keyboard to de-select the piece

      - If you want to quit without saving your game, press #{"CTRL-C".fg_color(:dark_red)} or #{"q".fg_color(:dark_red)}.
      - If you want to quit and save your progress, press #{"g".fg_color(:dark_green)}.

      - That's pretty much it! Good luck!
    HEREDOC
  end
end
