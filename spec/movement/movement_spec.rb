require_relative("./../../lib/movement/movement")
require_relative("./../../lib/movement/castling")
require_relative("./../../lib/movement/check_mate_stale")
require_relative("./../../lib/movement/en_passant")
require_relative("./../../lib/movement/pieces_moves")
require_relative("./../../lib/movement/promotion")
require_relative("./../../lib/movement/update_methods")
require_relative("./../../lib/board")
require_relative("./../../lib/constants")

describe Movement do
  describe "#can_move?" do
    let(:board) { Board.new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") }

    context "when move is available" do
      it "returns true" do
        following = [5, 3]
        available = [[1, 2], [2, 2], [0, 7], [5, 3], [4, 1]]
        check = board.can_move?(following, available)
        expect(check).to be(true)
      end
    end

    context "when move is not available" do
      it "returns false" do
        following = [5, 3]
        available = [[1, 2], [2, 2], [0, 7], [5, 2], [4, 1]]
        check = board.can_move?(following, available)
        expect(check).to be(false)
      end
    end

    context "when move is available but the spot to move has a king" do
      it "returns false" do
        following = [0, 4]
        available = [[0, 4], [2, 2], [0, 7], [5, 2], [4, 1]]
        check = board.can_move?(following, available)
        expect(check).to be(false)
      end
    end
  end

  describe "#in_range?" do
    let(:board) { Board.new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") }

    context "when a position is in range" do
      it "returns true for [0, 0]" do
        check = board.in_range?([0, 0])
        expect(check).to be(true)
      end

      it "returns true for [7, 7]" do
        check = board.in_range?([7, 7])
        expect(check).to be(true)
      end

      it "returns true for [5, 2]" do
        check = board.in_range?([5, 2])
        expect(check).to be(true)
      end
    end

    context "when a position is not in range" do
      it "returns false for [8, 2]" do
        check = board.in_range?([8, 2])
        expect(check).to be(false)
      end

      it "returns false for [-1, 4]" do
        check = board.in_range?([-1, 4])
        expect(check).to be(false)
      end
    end
  end

  describe "#update_piece" do
    let(:board) { Board.new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") }

    context "when a pawn" do
      let(:piece) { board.grid[6][0] }
      let(:empty) { "   " }

      before do
        board.update_piece(piece, [6, 0], [2, 0])
      end

      it "updates the piece correctly" do
        piece_position = board.grid[2][0]
        expect(piece_position).to eq(piece)
      end

      it "updates the previous spot correctly" do
        empty_position = board.grid[6][0].painted
        expect(empty_position).to eq(empty)
      end
    end

    context "when any other piece" do
      let(:piece) { board.grid[7][0] }
      let(:empty) { "   " }

      before do
        board.update_piece(piece, [7, 0], [5, 0])
      end

      it "updates the piece correctly" do
        piece_position = board.grid[5][0]
        expect(piece_position).to eq(piece)
      end

      it "updates the previous spot correctly" do
        empty_position = board.grid[7][0].painted
        expect(empty_position).to eq(empty)
      end
    end
  end

  describe "#promote" do
    context "when promoting to queen" do
      let(:board) { Board.new("8/P7/8/8/8/8/8/8 w KQkq - 0 1") }

      before do
        board.update_all_moves(board)
        to_queen = board.grid[1][0]
        allow(board).to receive(:puts).with("Please select the piece you want to replace your pawn with:")
        allow(board).to receive(:gets).and_return("1")
        board.move([1, 0], to_queen, [0, 0], :actual)
      end

      it "promotes successfuly" do
        piece = board.grid[0][0]
        expect(piece.piece).to eq(PIECES[:queen])
      end
    end

    context "when promoting to rook" do
      let(:board) { Board.new("8/P7/8/8/8/8/8/8 w KQkq - 0 1") }

      before do
        board.update_all_moves(board)
        to_rook = board.grid[1][0]
        allow(board).to receive(:puts).with("Please select the piece you want to replace your pawn with:")

        allow(board).to receive(:gets).and_return("2")
        board.move([1, 0], to_rook, [0, 0], :actual)
      end

      it "promotes successfuly" do
        piece = board.grid[0][0]
        expect(piece.piece).to eq(PIECES[:rook])
      end
    end

    context "when promoting to knight" do
      let(:board) { Board.new("8/P7/8/8/8/8/8/8 w KQkq - 0 1") }

      before do
        board.update_all_moves(board)
        to_knight = board.grid[1][0]
        allow(board).to receive(:puts).with("Please select the piece you want to replace your pawn with:")

        allow(board).to receive(:gets).and_return("3")
        board.move([1, 0], to_knight, [0, 0], :actual)
      end

      it "promotes successfuly" do
        piece = board.grid[0][0]
        expect(piece.piece).to eq(PIECES[:knight])
      end
    end

    context "when promoting to bishop" do
      let(:board) { Board.new("8/P7/8/8/8/8/8/8 w KQkq - 0 1") }

      before do
        board.update_all_moves(board)
        to_bishop = board.grid[1][0]
        allow(board).to receive(:puts).with("Please select the piece you want to replace your pawn with:")

        allow(board).to receive(:gets).and_return("4")
        board.move([1, 0], to_bishop, [0, 0], :actual)
      end

      it "promotes successfuly" do
        piece = board.grid[0][0]
        expect(piece.piece).to eq(PIECES[:bishop])
      end
    end
  end

  describe "#find_moves" do
    let(:wpawn) { Piece.new(:pawn, :white) { extend described_class } }
    let(:bqueen) { Piece.new(:queen, :black) { extend described_class } }
    let(:wknight) { Piece.new(:knight, :white) { extend described_class } }
    let(:brook) { Piece.new(:rook, :black) { extend described_class } }
    let(:wking) { Piece.new(:king, :white) { extend described_class } }
    let(:bbishop) { Piece.new(:bishop, :black) { extend described_class } }

    let(:board) { Board.new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") }

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
        let(:empty_board) { Board.new("8/8/8/8/8/8/8/8") }

        it "returns correct possible moves" do
          empty_board.grid[3][2] = Piece.new(:pawn, :black)
          movement = Queen.new.movement(empty_board, [2, 3], bqueen)
          directions = [[1, 3], [0, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [2, 2], [2, 1], [2, 0], [2, 4],
            [2, 5], [2, 6], [2, 7], [1, 2], [0, 1], [1, 4], [0, 5], [3, 4], [4, 5], [5, 6], [6, 7]]
          expect(movement).to eq(directions)
        end
      end

      context "when selecting a knight that that has every direction free" do
        let(:empty_board) { Board.new("8/8/8/8/8/8/8/8") }

        it "returns correct possible moves" do
          movement = Knight.new.movement(empty_board, [4, 4], wknight)
          directions = [[2, 3], [2, 5], [3, 2], [3, 6], [5, 2], [5, 6], [6, 3], [6, 5]]
          expect(movement).to eq(directions)
        end
      end

      context "when selecting a Rook that has an ally top side and an enemy on the immediate left" do
        let(:empty_board) { Board.new("8/8/8/8/8/8/8/8") }

        it "returns correct possible moves" do
          empty_board.grid[3][3] = Piece.new(:pawn, :black)
          empty_board.grid[4][2] = Piece.new(:pawn, :white)
          movement = Rook.new.movement(empty_board, [4, 3], brook)
          directions = [[5, 3], [6, 3], [7, 3], [4, 4], [4, 5], [4, 6], [4, 7], [4, 2]]
          expect(movement).to eq(directions)
        end
      end

      context "when selecting a King with every direction free" do
        let(:empty_board) { Board.new("8/8/8/8/8/8/8/8") }

        it "returns correct possible moves" do
          movement = King.new.movement(empty_board, [4, 3], wking)
          directions = [[3, 3], [5, 3], [4, 2], [4, 4], [3, 2], [3, 4], [5, 2], [5, 4]]
          expect(movement).to eq(directions)
        end
      end

      context "when selecting a bishop with every only one direction free" do
        let(:empty_board) { Board.new("8/8/8/8/8/8/8/8") }

        before do
          empty_board.grid[5][2] = Piece.new(:pawn, :black)
          empty_board.grid[5][4] = Piece.new(:pawn, :black)
          empty_board.grid[3][2] = Piece.new(:pawn, :black)
        end

        it "returns correct possible moves" do
          movement = Bishop.new.movement(empty_board, [4, 3], bbishop)
          directions = [[3, 4], [2, 5], [1, 6], [0, 7]]
          expect(movement).to eq(directions)
        end
      end
    end
    # No need to test enemy?, ally?, empty? because if find_moves works well, it means that those 3 methods work properly
  end
end
