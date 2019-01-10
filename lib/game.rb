require_relative './player'

class Game
  attr_reader :players
  attr_reader :end_game

  def initialize
    @players = []
    @end_game = false
  end

  def main
    puts '=' * 80
    puts 'Greed'
    puts '=' * 80
    puts 'How many players?'
    print '> '
    num_of_players = STDIN.gets
    num_of_players.to_i.times { @players.push(Player.new) }
  end
end