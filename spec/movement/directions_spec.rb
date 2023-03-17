require_relative("./../../lib/board")
require_relative("./../../lib/pieces/piece")
require_relative("./../../lib/movement/directions")

describe Directions do
  let(:wpawn) { Piece.new(:pawn, :white) { extend Directions } }
  let(:bqueen) { Piece.new(:queen, :black) { extend Directions } }
  let(:wknight) { Piece.new(:knight, :white) { extend Directions } }
  let(:brook) { Piece.new(:rook, :black) { extend Directions } }
  let(:wking) { Piece.new(:king, :white) { extend Directions } }
  let(:bbishop) { Piece.new(:bishop, :black) { extend Directions } }

  let(:board) { Board.new }

  before do
    board.populate
  end

  context "checks for the possible directions" do
    context "when selecting a pawn at the starting row" do
      it "returns correct possible moves" do
        movement = Pawn.new.movement(board, [6, 4], wpawn)
        directions = [[5, 4], [4, 4]]
        expect(movement).to eq(directions)
      end
    end

    context "when selecting a pawn on the starting row with enemies on both sides" do
      it "returns correct possible moves" do
        board.grid[5][5] = Piece.new(:pawn, :black)
        board.grid[5][3] = Piece.new(:pawn, :black)
        movement = Pawn.new.movement(board, [6, 4], wpawn)
        directions = [[5, 4], [4, 4], [5, 3], [5, 5]]
        expect(movement).to eq(directions)
      end
    end

    context "when selecting a queen that has one immediate ally to the side, but every other direction is free" do
      let(:empty_board) { Board.new }
      it "returns correct possible moves" do
        empty_board.grid[3][2] = Piece.new(:pawn, :black)
        movement = Queen.new.movement(empty_board, [2, 3], bqueen)
        directions = [[1, 3], [0, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [2, 2], [2, 1], [2, 0], [2, 4],
          [2, 5], [2, 6], [2, 7], [1, 2], [0, 1], [1, 4], [0, 5], [3, 4], [4, 5], [5, 6], [6, 7]]
        expect(movement).to eq(directions)
      end
    end

    context "when selecting a knight that that has every direction free" do
      let(:empty_board) { Board.new }
      it "returns correct possible moves" do
        movement = Knight.new.movement(empty_board, [4, 4], wknight)
        directions = [[2, 3], [2, 5], [3, 2], [3, 6], [5, 2], [5, 6], [6, 3], [6, 5]]
        expect(movement).to eq(directions)
      end
    end

    context "when selecting a Rook that has an ally top side and an enemy on the immediate left" do
      let(:empty_board) { Board.new }
      it "returns correct possible moves" do
        empty_board.grid[3][3] = Piece.new(:pawn, :black)
        empty_board.grid[4][2] = Piece.new(:pawn, :white)
        movement = Rook.new.movement(empty_board, [4, 3], brook)
        directions = [[5, 3], [6, 3], [7, 3], [4, 4], [4, 5], [4, 6], [4, 7], [4, 2]]
        expect(movement).to eq(directions)
      end
    end

    context "when selecting a King with every direction free" do
      let(:empty_board) { Board.new }
      it "returns correct possible moves" do
        movement = King.new.movement(empty_board, [4, 3], wking)
        directions = [[3, 3], [5, 3], [4, 2], [4, 4], [3, 2], [3, 4], [5, 2], [5, 4]]
        expect(movement).to eq(directions)
      end
    end

    context "when selecting a bishop with every only one direction free" do
      let(:empty_board) { Board.new }
      it "returns correct possible moves" do
        empty_board.grid[5][2] = Piece.new(:pawn, :black)
        empty_board.grid[5][4] = Piece.new(:pawn, :black)
        empty_board.grid[3][2] = Piece.new(:pawn, :black)
        movement = Bishop.new.movement(empty_board, [4, 3], bbishop)
        directions = [[3, 4], [2, 5], [1, 6], [0, 7]]
        expect(movement).to eq(directions)
      end
    end
  end
end
