require_relative './helper'
require_relative './dice_set'

class Turn
  attr_reader :player, :accumulated_score

  def initialize(player)
    @player = player
    @accumulated_score = 0
  end

  def main
    puts '=' * 6
    puts "Current Turn: Player #{player.number}"
    player.in_the_game? ? normal(5) : get_in_the_game
    puts '=' * 6
  end

  private

  def get_in_the_game
    puts "Player #{player.number} is not in the game."
    puts "You must get at least 300 points in this turn to get into the game.\n"
    score, num_of_available_dice = DiceSet.roll(5)
    if score >= 300
      accumulate_score_and_continue(score, num_of_available_dice)
    else
      puts "\nUnlucky, you\'re still not in the game."
    end
  end

  def normal(num_of_dice)
    score, num_of_available_dice = DiceSet.roll(num_of_dice)
    if score > 0
      accumulate_score_and_continue(score, num_of_available_dice)
    else
      puts "\nOh no! You've scored 0 points. You've lost your turn and accumulated score."
      puts "You currently have #{@player.points} points."
    end
  end

  def accumulate_score_and_continue(score, num_of_available_dice)
    @accumulated_score += score 
    puts "You have accumulated #{@accumulated_score} points this turn."
    ans = ask("\nRoll again with #{num_of_available_dice} dice? (y/n)")
    ['y', 'Y'].include?(ans) ? normal(num_of_available_dice) : add_accumulated_score_to_player_points
  end

  def add_accumulated_score_to_player_points
    @player.points += @accumulated_score
    if !@player.in_the_game?
      @player.in_the_game = true
      puts "\nYou are now in the game!"
    end
    puts "\nAdding your accumulated score to your points."
    puts "You now have #{@player.points} points!"
  end
end