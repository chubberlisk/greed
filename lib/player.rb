class Player
  attr_reader :points
  attr_reader :in_the_game

  def initialize
    @points = 0
    @in_the_game = false
  end

  def points=(val)
    @points = val
    @in_the_game = true if @points >= 300
  end
end