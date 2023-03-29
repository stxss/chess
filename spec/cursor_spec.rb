require_relative("./../lib/constants")
require_relative("./../lib/cursor")
require_relative("./../lib/board")

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

    context "when pressing q" do
      it "returns :ctrl_c" do
        allow($stdin).to receive(:getc).and_return("q")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:ctrl_c)
      end
    end

    context "when pressing ctrl_c" do
      it "returns :ctrl_c" do
        allow($stdin).to receive(:getc).and_return("\u0003")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:ctrl_c)
      end
    end

    context "when pressing escape" do
      it "returns :escape" do
        allow($stdin).to receive(:getc).and_return("\e")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:escape)
      end
    end

    context "when pressing return" do
      it "returns :return" do
        allow($stdin).to receive(:getc).and_return("\r")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:return)
      end
    end

    context "when pressing e" do
      it "returns :return" do
        allow($stdin).to receive(:getc).and_return("e")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:return)
      end
    end

    context "when pressing g" do
      it "returns :save" do
        allow($stdin).to receive(:getc).and_return("g")
        input = KEYS[cursor.ask_key]
        expect(input).to eq(:save)
      end
    end
  end

  describe "#interpret" do
    subject(:cursor) { described_class.new([5, 4], board) }

    let(:board) { Board.new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") }

    context "when has piece, is correct turn and presses return" do
      before do
        board.update_all_moves(board)
        cursor.interpret(:down)
        cursor.interpret(:return)
      end

      it "changes @selected state" do
        selected = cursor.instance_variable_get(:@selected)
        expect(selected).to be(true)
      end
    end

    context "when doesn't have piece and presses return" do
      before do
        board.update_all_moves(board)
        cursor.interpret(:up)
        cursor.interpret(:return)
      end

      it "does not change @selected state" do
        selected = cursor.instance_variable_get(:@selected)
        expect(selected).to be(false)
      end
    end

    context "when has piece, is not correct turn and presses return" do
      before do
        board.update_all_moves(board)

        moves = %i[return down return up return]
        moves.each { |move| cursor.interpret(move) }
      end

      it "does not change @selected state" do
        selected = cursor.instance_variable_get(:@selected)
        expect(selected).to be(false)
      end
    end

    context "when @selected is true and presses escape" do
      before do
        board.update_all_moves(board)
        moves = %i[down return escape]
        moves.each { |move| cursor.interpret(move) }
      end

      it "changes @selected state" do
        selected = cursor.instance_variable_get(:@selected)
        expect(selected).to be(false)
      end
    end

    context "when there is a stalemate" do
      subject(:cursor) { described_class.new([5, 4], board) }

      let(:board) { Board.new("2Q2bnr/4p1pq/5pkr/7p/7P/4P3/PPPP1PP1/RNB1KBNR w KQ - 1 10") }

      before do
        board.update_all_moves(board)
        moves = %i[up up up up up left left return
          down down right right return]

        moves.each { |move| cursor.interpret(move) }
      end

      it "returns true for stalemate" do
        stalemate = board.instance_variable_get(:@stalemate)
        expect(stalemate).to be(true)
      end
    end

    context "when there is a checkmate" do
      subject(:cursor) { described_class.new([5, 4], board) }

      let(:board) { Board.new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") }

      before do
        board.update_all_moves(board)
        moves = %i[down right return
          up return
          up up up up left return
          down return
          down down down down right right return
          up up return
          up up up up left left left return
          right right right right down down down down return]

        moves.each { |move| cursor.interpret(move) }
      end

      it "returns true for checkmate" do
        checkmate = board.instance_variable_get(:@checkmate)
        expect(checkmate).to be(true)
      end
    end

    context "when en_passant" do
      subject(:cursor) { described_class.new([5, 4], board) }

      let(:board) { Board.new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") }

      before do
        board.update_all_moves(board)
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

        moves.each { |move| cursor.interpret(move) }
      end

      it "does en passant correctly" do
        check_pos = board.grid[3][4]
        expect(check_pos.painted).to eq("   ")
      end
    end

    context "when castling white king side" do
      subject(:cursor) { described_class.new([5, 4], board) }

      let(:board) { Board.new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") }

      before do
        board.update_all_moves(board)
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

        moves.each { |move| cursor.interpret(move) }
      end

      it "white castles counter to 1" do
        expect(board.castles_white).to eq(1)
      end

      it "black castles counter is 0" do
        expect(board.castles_black).to eq(0)
      end
    end

    context "when castling black king side" do
      subject(:cursor) { described_class.new([5, 4], board) }

      let(:board) { Board.new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") }

      before do
        board.update_all_moves(board)
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

        moves.each { |move| cursor.interpret(move) }
      end

      it "black castles counter to 1" do
        expect(board.castles_black).to eq(1)
      end

      it "white castles counter is 0" do
        expect(board.castles_white).to eq(0)
      end
    end

    context "when castling white queen side" do
      subject(:cursor) { described_class.new([5, 4], board) }

      let(:board) { Board.new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") }

      before do
        board.update_all_moves(board)
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

        moves.each { |move| cursor.interpret(move) }
      end

      it "white castles counter to 1" do
        expect(board.castles_white).to eq(1)
      end

      it "black castles counter is 0" do
        expect(board.castles_black).to eq(0)
      end
    end

    context "when castling black queen side" do
      subject(:cursor) { described_class.new([5, 4], board) }

      let(:board) { Board.new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") }

      before do
        board.update_all_moves(board)
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

        moves.each { |move| cursor.interpret(move) }
      end

      it "black castles counter to 1" do
        expect(board.castles_black).to eq(1)
      end

      it "white castles counter is 0" do
        expect(board.castles_white).to eq(0)
      end
    end
  end

  describe "#update_cursor" do
    subject(:cursor) { described_class.new([5, 4], board) }

    let(:board) { Board.new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") }

    context "when user presses up" do
      before do
        cursor.interpret(:up)
      end

      it "updates cursor correctly" do
        position = cursor.instance_variable_get(:@current_pos)
        expect(position).to eq([4, 4])
      end
    end

    context "when user presses down" do
      before do
        cursor.interpret(:down)
      end

      it "updates cursor correctly" do
        position = cursor.instance_variable_get(:@current_pos)
        expect(position).to eq([6, 4])
      end
    end

    context "when user presses left" do
      before do
        cursor.interpret(:left)
      end

      it "updates cursor correctly" do
        position = cursor.instance_variable_get(:@current_pos)
        expect(position).to eq([5, 3])
      end
    end

    context "when user presses right" do
      before do
        cursor.interpret(:right)
      end

      it "updates cursor correctly" do
        position = cursor.instance_variable_get(:@current_pos)
        expect(position).to eq([5, 5])
      end
    end

    context "when user presses up, left, up, right, right, right, up" do
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
        position = cursor.instance_variable_get(:@current_pos)
        expect(position).to eq([2, 6])
      end
    end

    context "when user presses left, left, up, up, up, up, up, up, up, up" do
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
        position = cursor.instance_variable_get(:@current_pos)
        expect(position).to eq([0, 2])
      end
    end
  end
end
