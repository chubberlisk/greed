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
    valid_num_of_players = false
    while !valid_num_of_players
      puts 'How many players?'
      print '> '
      num_of_players = STDIN.gets.to_i
      if (2..6).include?(num_of_players)
        num_of_players.times { @players.push(Player.new) }
        valid_num_of_players = true
      else
        puts "Please enter a number between 2 and 6.\n\n"
      end
    end
  end
end