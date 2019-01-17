class Player
  attr_reader :number
  attr_reader :points
  attr_writer :in_the_game
  attr_writer :final_turn

  def initialize(number)
    @number = number
    @points = 0
    @in_the_game = false
    @final_turn = false
  end

  def points=(val)
    @points = val
    @in_the_game = true if @points >= 300
    @final_turn = true if @points >= 3000
  end

  def in_the_game?
    @in_the_game
  end

  def final_turn?
    @final_turn
  end
end