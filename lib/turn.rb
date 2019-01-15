require_relative './player'
require_relative './dice_set'

class Turn
  attr_reader :player, :accumulated_score, :end

  def initialize(player)
    @player = player
    @accumulated_score = 0
    @end = false
  end

  def main
    puts '=' * 6
    puts "Current Turn: Player #{player.number}"
    puts "Player #{player.number} is #{'not ' if !player.in_the_game?}in the game."
    dice_set = DiceSet.new
    dice_set.roll(5)
    puts "You must get at least 300 points in this turn to get into the game.\n\n"
    puts "You rolled #{dice_set.values} with a score of #{dice_set.score}."
    if dice_set.score >= 300
      @accumulated_score += dice_set.score 
      @player.in_the_game = true
      puts "\nYou are now in the game!"
      puts "You have accumulated #{@accumulated_score} points this turn."
      ans = ask("\nRoll again with #{dice_set.num_of_available_dice} dice? (y/n)")
      if ['y', 'Y', 'yes', 'YES'].include?(ans)
        dice_set.roll(dice_set.num_of_available_dice)
        puts "\nYou rolled #{dice_set.values} with a score of #{dice_set.score}."
      else
        @player.points += @accumulated_score
        puts "\nAdding your accumulated score to your points."
        puts "You now have #{@player.points} points!"
      end
    else
      puts "\nUnlucky, you\'re still not in the game."
    end
    puts '=' * 6
  end

  private

  def ask(question)
    puts question
    print '> '
    STDIN.gets.chomp
  end
end

# Turn.new(Player.new(1)).main