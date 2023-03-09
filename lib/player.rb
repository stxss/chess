class Player
  attr_accessor :name, :score

  def initialize(name, score = 0)
    @name = name
    @score = score
  end
end
