class Player
  attr_reader :number
  attr_reader :points

  def initialize(number)
    @number = number
    @points = 0
    @in_the_game = false
  end

  def points=(val)
    @points = val
    @in_the_game = true if @points >= 300
  end

  def in_the_game?
    @in_the_game
  end
end