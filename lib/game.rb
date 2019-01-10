class Game
  attr_reader :players
  attr_reader :end_game

  def initialize(players)
    @players = players
    @end_game = false
  end
end