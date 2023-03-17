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
