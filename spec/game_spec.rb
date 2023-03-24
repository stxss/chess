require_relative("../lib/player")
require_relative("../lib/display")
require_relative("../lib/game")

describe Game do
  describe "#give_name" do
    subject(:game) { described_class.new }

    context "when user inputs a symbol and a valid name" do
      before do
        symbol = "#"
        valid = "odin"
        allow(game).to receive(:gets).and_return(symbol, valid)
      end

      it "returns name asking message twice when creating first player" do
        ask_message = "\nPlease, enter a valid name for the first player: "
        expect(game).to receive(:puts).with(ask_message).twice
        game.give_name
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
        game.give_name(valid)
      end
    end
  end
end
