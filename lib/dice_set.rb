class DiceSet
  class << self
    def roll(num_of_dice)
      @values = (0...num_of_dice).map { rand(1..6) }
      puts "\nYou rolled #{@values} with a score of #{score[:val]}."
      return score[:val], num_of_available_dice 
    end

    def score
      score = { val: 0, dice: 0 }
      values_c = @values.clone
      values_c.uniq.each do |num|
        if values_c.count(num) >= 3
          num == 1 ? score[:val] += 1000 : score[:val] += num * 100
          3.times { values_c.delete_at(values_c.index(num)) }
          score[:dice] += 3
        end
      end
      values_c.each.with_index do |num, i|
        if num == 1 || num == 5
          num == 1 ? score[:val] += 100 : score[:val] += 50
          score[:dice] += 1
        end
      end
      score
    end

    def num_of_available_dice
      num_of_non_scoring = @values.size - score[:dice]
      case num_of_non_scoring
      when 0
        num_of_available_dice = 5
      when 5
        num_of_available_dice = 0
      else
        num_of_available_dice = num_of_non_scoring
      end
    end
  end
end