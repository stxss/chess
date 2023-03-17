require_relative("./../lib/pieces/piece")
require_relative("./../lib/board")

describe Board do
  describe "#populate" do
    subject(:board) { described_class.new }
    let(:brook) { Piece.new(:rook, :black) }
    let(:bknight) { Piece.new(:knight, :black) }
    let(:bbishop) { Piece.new(:bishop, :black) }
    let(:bqueen) { Piece.new(:queen, :black) }
    let(:bking) { Piece.new(:king, :black) }
    let(:bpawn) { Piece.new(:pawn, :black) }

    let(:wrook) { Piece.new(:rook, :white) }
    let(:wknight) { Piece.new(:knight, :white) }
    let(:wbishop) { Piece.new(:bishop, :white) }
    let(:wqueen) { Piece.new(:queen, :white) }
    let(:wking) { Piece.new(:king, :white) }
    let(:wpawn) { Piece.new(:pawn, :white) }

    before do
      board.populate
    end

    context "regarding black pieces" do
      it "places the first rook" do
        board_symbol = board.grid[0][0]
        check = board_symbol.piece == brook.piece && board_symbol.color == :black
        expect(check).to eq(true)
      end

      it "places the second rook" do
        board_symbol = board.grid[0][7]
        check = board_symbol.piece == brook.piece && board_symbol.color == :black
        expect(check).to eq(true)
      end

      it "places the first knight" do
        board_symbol = board.grid[0][1]
        check = board_symbol.piece == bknight.piece && board_symbol.color == :black
        expect(check).to eq(true)
      end

      it "places the second knight" do
        board_symbol = board.grid[0][6]
        check = board_symbol.piece == bknight.piece && board_symbol.color == :black
        expect(check).to eq(true)
      end

      it "places the first bishop" do
        board_symbol = board.grid[0][2]
        check = board_symbol.piece == bbishop.piece && board_symbol.color == :black
        expect(check).to eq(true)
      end

      it "places the second bishop" do
        board_symbol = board.grid[0][5]
        check = board_symbol.piece == bbishop.piece && board_symbol.color == :black
        expect(check).to eq(true)
      end

      it "places the queen" do
        board_symbol = board.grid[0][3]
        check = board_symbol.piece == bqueen.piece && board_symbol.color == :black
        expect(check).to eq(true)
      end

      it "places the king" do
        board_symbol = board.grid[0][4]
        check = board_symbol.piece == bking.piece && board_symbol.color == :black
        expect(check).to eq(true)
      end

      it "places the pawns " do
        pawns = []
        colors = []
        8.times do |i|
          pawns << board.grid[1][i].piece
          colors << board.grid[1][i].color
        end
        check = pawns.all?(bpawn.piece) && colors.all?(bpawn.color)
        expect(check).to eq(true)
      end
    end

    context "regarding white pieces" do
      it "places the first rook" do
        board_symbol = board.grid[7][0]
        check = board_symbol.piece == wrook.piece && board_symbol.color == :white
        expect(check).to eq(true)
      end

      it "places the second rook" do
        board_symbol = board.grid[7][7]
        check = board_symbol.piece == wrook.piece && board_symbol.color == :white
        expect(check).to eq(true)
      end

      it "places the first knight" do
        board_symbol = board.grid[7][1]
        check = board_symbol.piece == wknight.piece && board_symbol.color == :white
        expect(check).to eq(true)
      end

      it "places the second knight" do
        board_symbol = board.grid[7][6]
        check = board_symbol.piece == wknight.piece && board_symbol.color == :white
        expect(check).to eq(true)
      end

      it "places the first bishop" do
        board_symbol = board.grid[7][2]
        check = board_symbol.piece == wbishop.piece && board_symbol.color == :white
        expect(check).to eq(true)
      end

      it "places the second bishop" do
        board_symbol = board.grid[7][5]
        check = board_symbol.piece == wbishop.piece && board_symbol.color == :white
        expect(check).to eq(true)
      end

      it "places the queen" do
        board_symbol = board.grid[7][3]
        check = board_symbol.piece == wqueen.piece && board_symbol.color == :white
        expect(check).to eq(true)
      end

      it "places the king" do
        board_symbol = board.grid[7][4]
        check = board_symbol.piece == wking.piece && board_symbol.color == :white
        expect(check).to eq(true)
      end

      it "places the pawns " do
        pawns = []
        colors = []
        8.times do |i|
          pawns << board.grid[6][i].piece
          colors << board.grid[6][i].color
        end
        check = pawns.all?(wpawn.piece) && colors.all?(wpawn.color)
        expect(check).to eq(true)
      end
    end
  end
end
