KEYS = {
  "w"      => :up,
  "s"      => :down,
  "a"      => :left,
  "d"      => :right,
  "k"      => :up,
  "j"      => :down,
  "h"      => :left,
  "l"      => :right,
  "\e[A"   => :up,
  "\e[B"   => :down,
  "\e[D"   => :left,
  "\e[C"   => :right,
  "z"      => :queen_side,
  "x"      => :king_side,
  "e"      => :return,
  "\r"     => :return,
  "q"      => :ctrl_c,
  "\e"     => :escape,
  "g"      => :save,
  "\177"   => :backspace,
  "\004"   => :delete,
  "\t"     => :tab,
  "\n"     => :newline,
  "\u0003" => :ctrl_c
}.freeze

MOVE = {
  up:         [-1, 0],
  down:       [1, 0],
  left:       [0, -1],
  right:      [0, 1],
  up_left:    [-1, -1],
  up_right:   [-1, 1],
  down_left:  [1, -1],
  down_right: [1, 1]
}.freeze

PIECES = {
  king:   " \u{265A} ",
  queen:  " \u{265B} ",
  rook:   " \u{265C} ",
  bishop: " \u{265D} ",
  knight: " \u{265E} ",
  pawn:   " \u{265F} "
}.freeze
