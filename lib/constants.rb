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

CASTLE_VARS = {
  white: {
    king:  [[7, 5], [7, 6]],
    queen: [[7, 3], [7, 2], [7, 1]]
  },
  black: {
    king:  [[0, 5], [0, 6]],
    queen: [[0, 3], [0, 2], [0, 1]]
  }
}.freeze

FEN = {
  white: {
    king:   "K",
    queen:  "Q",
    rook:   "R",
    bishop: "B",
    knight: "N",
    pawn:   "P"
  },
  black: {
    king:   "k",
    queen:  "q",
    rook:   "r",
    bishop: "b",
    knight: "n",
    pawn:   "p"
  },
  empty: 1
}

NAMED_SQUARES = {
  [0, 0] => "a8",
  [0, 1] => "b8",
  [0, 2] => "c8",
  [0, 3] => "d8",
  [0, 4] => "e8",
  [0, 5] => "f8",
  [0, 6] => "g8",
  [0, 7] => "h8",
  [1, 0] => "a7",
  [1, 1] => "b7",
  [1, 2] => "c7",
  [1, 3] => "d7",
  [1, 4] => "e7",
  [1, 5] => "f7",
  [1, 6] => "g7",
  [1, 7] => "h7",
  [2, 0] => "a6",
  [2, 1] => "b6",
  [2, 2] => "c6",
  [2, 3] => "d6",
  [2, 4] => "e6",
  [2, 5] => "f6",
  [2, 6] => "g6",
  [2, 7] => "h6",
  [3, 0] => "a5",
  [3, 1] => "b5",
  [3, 2] => "c5",
  [3, 3] => "d5",
  [3, 4] => "e5",
  [3, 5] => "f5",
  [3, 6] => "g5",
  [3, 7] => "h5",
  [4, 0] => "a4",
  [4, 1] => "b4",
  [4, 2] => "c4",
  [4, 3] => "d4",
  [4, 4] => "e4",
  [4, 5] => "f4",
  [4, 6] => "g4",
  [4, 7] => "h4",
  [5, 0] => "a3",
  [5, 1] => "b3",
  [5, 2] => "c3",
  [5, 3] => "d3",
  [5, 4] => "e3",
  [5, 5] => "f3",
  [5, 6] => "g3",
  [5, 7] => "h3",
  [6, 0] => "a2",
  [6, 1] => "b2",
  [6, 2] => "c2",
  [6, 3] => "d2",
  [6, 4] => "e2",
  [6, 5] => "f2",
  [6, 6] => "g2",
  [6, 7] => "h2",
  [7, 0] => "a1",
  [7, 1] => "b1",
  [7, 2] => "c1",
  [7, 3] => "d1",
  [7, 4] => "e1",
  [7, 5] => "f1",
  [7, 6] => "g1",
  [7, 7] => "h1"
}.freeze

TRANSLATE = {
  "r" => :rook,
  "n" => :knight,
  "b" => :bishop,
  "q" => :queen,
  "k" => :king,
  "p" => :pawn,
  "R" => :rook,
  "N" => :knight,
  "B" => :bishop,
  "Q" => :queen,
  "K" => :king,
  "P" => :pawn
}.freeze
