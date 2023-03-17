describe Movement do
  describe "#can_move?" do
    let(:board) { Board.new { extend Movement } }

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
    let(:board) { Board.new { extend Movement } }

    before do
      board.populate
    end

    context "when a position is in range" do
      it "returns true" do
        check = board.in_range?([0, 0])
        expect(check).to be(true)
      end

      it "returns true" do
        check = board.in_range?([7, 7])
        expect(check).to be(true)
      end

      it "returns true" do
        check = board.in_range?([5, 2])
        expect(check).to be(true)
      end
    end

    context "when a position is not in range" do
      it "returns false" do
        check = board.in_range?([8, 2])
        expect(check).to be(false)
      end

      it "returns false" do
        check = board.in_range?([-1, 4])
        expect(check).to be(false)
      end
    end
  end

  describe "#is_empty?" do
    let(:board) { Board.new { extend Movement } }

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
end
