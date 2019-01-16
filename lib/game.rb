require_relative './turn'
require_relative './player'

class Game
  attr_reader :players
  attr_reader :turn
  attr_reader :end_game

  def initialize
    @players = []
    @turn = 1
    @end_game = false
  end

  def main
    step_0_intro
    step_1_num_of_players until @players.size >= 2
    Turn.new(@players.first).main
  end

  def players_in_the_game
    @players.select { |player| player.in_the_game? }
  end

  def turn_player
    @players.find { |player| player.number == turn }
  end

  private

  def ask(question)
    puts question
    print '> '
    STDIN.gets.chomp
  end

  def step_0_intro
    puts '=' * 80
    puts 'Greed'
    puts '=' * 80
  end

  def step_1_num_of_players
    num_of_players = ask('How many players?').to_i
    if num_of_players.between?(2, 6)
      num_of_players.times { |i| @players.push(Player.new(i + 1)) }
    else
      puts "Please enter a number between 2 and 6.\n"
    end
    puts
  end
end