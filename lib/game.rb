require_relative './player'
require_relative './dice_set'

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
    step_2_turns
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

  def step_2_turns
    # while !end_game
      puts '=' * 6
      puts "Current Turn: Player #{turn_player.number}"
      puts "Player #{turn_player.number} is not in the game."
      puts "You must get at least 300 points in this turn to get into the game.\n\n"
      dice_set = DiceSet.new
      dice_set.roll(5)
      puts "You rolled #{dice_set.values} with a score of #{dice_set.score}."
      if dice_set.score >= 300
        turn_player.points += dice_set.score
        puts "You are now in the game! You have #{turn_player.points} points."
        num_of_dice = dice_set.num_of_non_scoring == 0 ? 5 : dice_set.num_of_non_scoring
        ans = ask("Roll again with #{num_of_dice} dice? (y/n)")
        if ans == 'y'
          dice_set.roll(num_of_dice)
          puts "You rolled #{dice_set.values} with a score of #{dice_set.score}."
          turn_player.points += dice_set.score
          puts "You have #{turn_player.points} points."
        end
      else
        puts 'Unlucky, you\'re still not in the game.'
      end
      puts '=' * 6
    # end
  end
end