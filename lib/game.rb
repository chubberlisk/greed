require_relative './helper'
require_relative './turn'
require_relative './player'

class Game
  attr_reader :players

  def initialize
    @players = []
    @final_round = false
    @end_game = false
  end

  def main
    step_0_intro
    step_1_num_of_players until @players.size >= 2
    step_2_turns until @end_game
    step_3_game_over
  end

  def players_in_the_game
    @players.select { |player| player.in_the_game? }
  end

  def final_round?
    @final_round
  end

  def end_game?
    @end_game
  end

  def highest_scorer
    @players.max { |player| player.points }
  end

  private

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
      puts "\nPlease enter a number between 2 and 6."
    end
  end

  def step_2_turns
    @players.each do |player|
      unless player.final_turn?
        Turn.new(player).main
        @final_round = true if player.final_turn?
        player.final_turn = true if @final_round
        @end_game = true if @players.all? { |player| player.final_turn? }
        ans = ask("\nPress any key to continue or (n/q) to stop.")
        if ['n', 'N', 'q', 'Q'].include?(ans)
          @end_game = true
          break
        end
      end
    end
  end

  def step_3_game_over
    puts "\n" + '=' * 80
    puts "GAME OVER!"
    puts "\nThe winner is Player #{highest_scorer.number}!"
    puts "\nEach player scored:"
    @players.each do |player|
      puts " - Player #{player.number}: #{player.points} points"
    end
    puts '=' * 80
  end
end