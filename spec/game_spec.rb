require_relative("../lib/game")

describe Game do
  describe "#create" do
    subject(:game) { described_class.new }

    context "when user inputs a symbol and a valid name" do
      before do
        symbol = "#"
        valid = "odin"
        allow(game).to receive(:gets).and_return(symbol, valid)
      end

      it "returns name asking message twice when creating first player" do
        ask_message = "\nPlease, enter a valid name for the first player: "
        expect(game).to receive(:puts).with(ask_message).exactly(2).times
        game.create
      end
    end

    context "when user inputs a symbol, a valid name, a number, the first valid name and finally a valid second name" do
      before do
        valid = "odin"
        number = "3"
        second_valid = "ruby"
        allow(game).to receive(:gets).and_return(valid, number, second_valid)
      end
      it "returns name asking message three times" do
        ask_message_second = "\nPlease, enter a valid name for the second player: "
        valid = "odin"
        expect(game).to receive(:puts).with(ask_message_second).exactly(3).times
        game.create(valid)
      end
    end
  end

  describe "#play" do
    subject(:game) { described_class.new }

    context "when there's a draw" do
      before do
        allow(game).to receive(:has_winner?).and_return(false)
        allow(game).to receive(:draw?).and_return(true)
        allow(game).to receive(:restart)
      end

      it "returns a draw prompt" do
        draw_message = "\nIt's a draw!"
        expect(game).to receive(:puts).with(draw_message).once
        game.play
      end
    end

    context "when a winner is found" do
      before do
        allow(game).to receive(:draw?).and_return(false)
        allow(game).to receive(:has_winner?).and_return(true)
        allow(game).to receive(:restart)
      end

      it "returns a win prompt" do
        win_message = "\nThere's a winner!"
        expect(game).to receive(:puts).with(win_message).once
        game.play
      end
    end
  end
end
