require_relative './player'

class Game
  attr_reader :players
  attr_reader :end_game

  def initialize
    @players = []
    @end_game = false
  end

  def main
    step_0_intro
    step_1_num_of_players until @players.size >= 2
  end

  private

  def ask(question)
    puts question
    print '> '
    STDIN.gets
  end

  def step_0_intro
    puts '=' * 80
    puts 'Greed'
    puts '=' * 80
  end

  def step_1_num_of_players
    num_of_players = ask('How many players?').to_i
    if num_of_players.between?(2, 6)
      num_of_players.times { @players.push(Player.new) }
    else
      puts "Please enter a number between 2 and 6.\n\n"
    end
  end
end