require_relative("./../lib/cursor")

describe Cursor do
  describe "#ask_key" do
    subject(:cursor) { described_class.new([5, 4], []) }

    context "when pressing up arrow" do
      before do
        allow($stdin).to receive(:read_nonblock).with(3).and_return("[A")
        allow($stdin).to receive(:read_nonblock).with(2)
        allow($stdin).to receive(:getc).and_return("\e[A")
      end

      it "returns :up" do
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:up)
      end
    end

    context "when pressing 'w'" do
      it "returns :up" do
        allow($stdin).to receive(:getc).and_return("w")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:up)
      end
    end

    context "when pressing 'k'" do
      it "returns :up" do
        allow($stdin).to receive(:getc).and_return("k")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:up)
      end
    end

    context "when pressing down arrow" do
      before do
        allow($stdin).to receive(:read_nonblock).with(3).and_return("[B")
        allow($stdin).to receive(:read_nonblock).with(2)
        allow($stdin).to receive(:getc).and_return("\e[B")
      end

      it "returns :down" do
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:down)
      end
    end

    context "when pressing 's'" do
      it "returns :down" do
        allow($stdin).to receive(:getc).and_return("s")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:down)
      end
    end

    context "when pressing 'j'" do
      it "returns :down" do
        allow($stdin).to receive(:getc).and_return("j")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:down)
      end
    end

    context "when pressing left arrow" do
      before do
        allow($stdin).to receive(:read_nonblock).with(3).and_return("[D")
        allow($stdin).to receive(:read_nonblock).with(2)
        allow($stdin).to receive(:getc).and_return("\e[D")
      end
      it "returns :left" do
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:left)
      end
    end

    context "when pressing 'a'" do
      it "returns :left" do
        allow($stdin).to receive(:getc).and_return("a")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:left)
      end
    end

    context "when pressing 'h'" do
      it "returns :left" do
        allow($stdin).to receive(:getc).and_return("h")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:left)
      end
    end

    context "when pressing right arrow" do
      before do
        allow($stdin).to receive(:read_nonblock).with(3).and_return("[C")
        allow($stdin).to receive(:read_nonblock).with(2)
        allow($stdin).to receive(:getc).and_return("\e[C")
      end

      it "returns :right" do
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:right)
      end
    end

    context "when pressing 'd'" do
      it "returns :right" do
        allow($stdin).to receive(:getc).and_return("d")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:right)
      end
    end

    context "when pressing 'l'" do
      it "returns :right" do
        allow($stdin).to receive(:getc).and_return("l")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:right)
      end
    end

    context "pressing q" do
      it "returns :ctrl_c" do
        allow($stdin).to receive(:getc).and_return("q")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:ctrl_c)
      end
    end

    context "pressing ctrl_c" do
      it "returns :ctrl_c" do
        allow($stdin).to receive(:getc).and_return("\u0003")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:ctrl_c)
      end
    end

    context "pressing escape" do
      it "returns :escape" do
        allow($stdin).to receive(:getc).and_return("\e")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:escape)
      end
    end

    context "pressing return" do
      it "returns :return" do
        allow($stdin).to receive(:getc).and_return("\r")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:return)
      end
    end

    context "pressing return" do
      it "returns :return" do
        allow($stdin).to receive(:getc).and_return("e")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:return)
      end
    end

    context "pressing g" do
      it "returns :save" do
        allow($stdin).to receive(:getc).and_return("g")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:save)
      end
    end
  end

  describe "#interpret" do
    let(:board) { Board.new }
    subject(:cursor) { described_class.new([6, 4], board) }

    context "when has piece, is correct turn and presses return" do
      before do
        board.populate
        allow(cursor).to receive(:has_piece?).and_return(true)
        allow(cursor).to receive(:correct_turn?).and_return(true)
        cursor.interpret(:return)
      end

      it "changes @selected state" do
        selected = cursor.instance_variable_get(:@selected)
        expect(selected).to be(true)
      end
    end

    context "when doesn't have piece, is not correct turn and presses return" do
      before do
        board.populate
        allow(cursor).to receive(:has_piece?).and_return(false)
        allow(cursor).to receive(:correct_turn?).and_return(false)
        cursor.interpret(:return)
      end

      it "does not change @selected state" do
        selected = cursor.instance_variable_get(:@selected)
        expect(selected).to be(false)
      end
    end

    context "when doesn't have piece, is correct turn and presses return" do
      before do
        board.populate
        allow(cursor).to receive(:has_piece?).and_return(false)
        allow(cursor).to receive(:correct_turn?).and_return(true)
        cursor.interpret(:return)
      end

      it "does not change @selected state" do
        selected = cursor.instance_variable_get(:@selected)
        expect(selected).to be(false)
      end
    end

    context "when has piece, is not correct turn and presses return" do
      before do
        board.populate
        allow(cursor).to receive(:has_piece?).and_return(true)
        allow(cursor).to receive(:correct_turn?).and_return(false)
        cursor.interpret(:return)
      end

      it "does not change @selected state" do
        selected = cursor.instance_variable_get(:@selected)
        expect(selected).to be(false)
      end
    end

    context "when @selected is true and presses escape" do
      before do
        board.populate
        allow(cursor).to receive(:has_piece?).and_return(true)
        allow(cursor).to receive(:correct_turn?).and_return(true)
        cursor.interpret(:escape)
      end

      it "changes @selected state" do
        selected = cursor.instance_variable_get(:@selected)
        expect(selected).to be(false)
      end
    end

    context "there is a stalemate" do
      let(:board) { Board.new }
      subject(:cursor) { described_class.new([5, 4], board) }

      before do
        board.populate
        moves = %i[down return up return
          up up up up left left left left return
          down down return
          down down down down right right right return
          right right right right up up up up return
          left left left left left left left up up up return
          down down return
          right right right right right right right down return
          left left left left left left left return
          up right right right right right right right up return
          down down return
          down down down return
          up up return
          left left left left left left left up up return
          right right right right right right right return
          left left left left left left left down return
          up right up right return
          right right right return
          down return
          left left left up return
          right return
          up right return
          down right return
          left left return
          left left return
          up right right return
          down down down down down return
          up up up up left left return
          up return
          down down down down down right right return
          up up up up right right right right return
          up left left left left left left return
          right return
          down right right right return
          down right return
          up up left left left left return
          right right down down return]

        moves.each do |move|
          cursor.interpret(move)
        end
      end

      it "returns true for stalemate" do
        stalemate = cursor.instance_variable_get(:@stalemate)
        expect(stalemate).to eq(true)
      end
    end

    context "there is a checkmate" do
      let(:board) { Board.new }
      subject(:cursor) { described_class.new([5, 4], board) }

      before do
        board.populate
        moves = %i[down right return
          up return
          up up up up left return
          down return
          down down down down right right return
          up up return
          up up up up left left left return
          right right right right down down down down return]

        moves.each do |move|
          cursor.interpret(move)
        end
      end

      it "returns true for checkmate" do
        checkmate = cursor.instance_variable_get(:@checkmate)
        expect(checkmate).to eq(true)
      end
    end

    context "handles en_passant" do
      let(:board) { Board.new }
      subject(:cursor) { described_class.new([5, 4], board) }

      it "does en passant correctly" do
        board.populate
        moves = %i[down right return
          up up return
          up up up left left left left left return
          down return
          right right right right right
          down down return
          up return
          up up left return
          down down return
          right return up left return]

        moves.each do |move|
          cursor.interpret(move)
        end
        check_pos = board.grid[3][4]
        expect(check_pos.symbol).to eq("   ")
      end

      it "returns true for ep_flag" do
        board.populate
        moves = %i[down right return
          up up return
          up up up left left left left left return
          down return
          right right right right right
          down down return
          up return
          up up left return
          down down return
          right return]

        moves.each do |move|
          cursor.interpret(move)
        end
        check_pos = board.grid[3][4]
        expect(check_pos.ep_flag).to eq(true)
      end
    end

    context "handles castle" do
      let(:board) { Board.new }
      subject(:cursor) { described_class.new([5, 4], board) }

      it "castles white king side correctly" do
        board.populate
        moves = %i[down right return
          up return
          up up up up return
          down return
          down down down down right return
          up return
          up up up up return
          down return
          down down down down down return
          right up up return
          up up up up up left return
          right down down return
          down down down down down left left return
          up right return
          up up up up up up left return
          right down return
          king_side]

        moves.each do |move|
          cursor.interpret(move)
        end

        expect(board.castles_white).to eq(1)
        expect(board.castles_black).to eq(0)
      end

      it "castles black king side correctly" do
        board.populate
        moves = %i[down right return
          up return
          up up up up return
          down return
          down down down down right return
          up return
          up up up up return
          down return
          down down down down down return
          right up up return
          up up up up up left return
          right down down return
          down down down down down left left return
          up right return
          up up up up up up left return
          right down return
          down down down down return
          up return
          king_side]

        moves.each do |move|
          cursor.interpret(move)
        end

        expect(board.castles_white).to eq(0)
        expect(board.castles_black).to eq(1)
      end

      it "castles white queen side correctly" do
        board.populate
        moves = %i[down left return
          up return
          up up up up return
          down return
          down down down down left return
          up return
          up up up up return
          down return
          down down down down down return
          right up return
          up up up up up up return
          down left return
          down down down down down down right return
          left up return
          up up up up up up return
          right down return
          down down down down down down left left return
          up up left return
          up up up up return
          down return
          queen_side]

        moves.each do |move|
          cursor.interpret(move)
        end

        expect(board.castles_white).to eq(1)
        expect(board.castles_black).to eq(0)
      end

      it "castles black queen side correctly" do
        board.populate
        moves = %i[down left return
          up return
          up up up up return
          down return
          down down down down left return
          up return
          up up up up return
          down return
          down down down down down return
          right up return
          up up up up up up return
          down left return
          down down down down down down right return
          left up return
          up up up up up up return
          right down return
          down down down down down down left left return
          up up left return
          up up up up up right return
          down down left return
          down down down return
          up right right return
          queen_side]

        moves.each do |move|
          cursor.interpret(move)
        end

        expect(board.castles_white).to eq(0)
        expect(board.castles_black).to eq(1)
      end
    end
  end

  describe "#update_cursor" do
    let(:board) { Board.new }
    subject(:cursor) { described_class.new([5, 4], board) }

    context "user presses up" do
      before do
        cursor.interpret(:up)
      end

      it "updates cursor correctly" do
        position = cursor.instance_variable_get(:@cursor_pos)
        expect(position).to eq([4, 4])
      end
    end

    context "user presses down" do
      before do
        cursor.interpret(:down)
      end

      it "updates cursor correctly" do
        position = cursor.instance_variable_get(:@cursor_pos)
        expect(position).to eq([6, 4])
      end
    end

    context "user presses left" do
      before do
        cursor.interpret(:left)
      end

      it "updates cursor correctly" do
        position = cursor.instance_variable_get(:@cursor_pos)
        expect(position).to eq([5, 3])
      end
    end

    context "user presses right" do
      before do
        cursor.interpret(:right)
      end

      it "updates cursor correctly" do
        position = cursor.instance_variable_get(:@cursor_pos)
        expect(position).to eq([5, 5])
      end
    end

    context "user presses up, left, up, right, right, right, up" do
      before do
        cursor.interpret(:up)
        cursor.interpret(:left)
        cursor.interpret(:up)
        cursor.interpret(:right)
        cursor.interpret(:right)
        cursor.interpret(:right)
        cursor.interpret(:up)
      end

      it "updates cursor correctly" do
        position = cursor.instance_variable_get(:@cursor_pos)
        expect(position).to eq([2, 6])
      end
    end

    context "user presses left, left, up, up, up, up, up, up, up, up" do
      before do
        cursor.interpret(:left)
        cursor.interpret(:left)
        cursor.interpret(:up)
        cursor.interpret(:up)
        cursor.interpret(:up)
        cursor.interpret(:up)
        cursor.interpret(:up)
        cursor.interpret(:up)
        cursor.interpret(:up)
        cursor.interpret(:up)
      end

      it "updates cursor correctly and then does not go further" do
        position = cursor.instance_variable_get(:@cursor_pos)
        expect(position).to eq([0, 2])
      end
    end
  end
end
