describe Movement do
  describe "#can_move?" do
    let(:board) { Board.new }

    before do
      board.populate
    end

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
    let(:board) { Board.new }

    before do
      board.populate
    end

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

  describe "#is_empty?" do
    let(:board) { Board.new }

    before do
      board.populate
    end

    context "when a position is empty" do
      it "returns true" do
        check = board.is_empty?([5, 3])
        expect(check).to be(true)
      end
    end

    context "when a position is not empty" do
      it "returns false" do
        check = board.is_empty?([0, 0])
        expect(check).to be(false)
      end
    end
  end

  describe "#update_piece" do
    let(:board) { Board.new }

    before do
      board.populate
    end

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
end
