class DiceSet
  attr_reader :values
  attr_reader :num_of_non_scoring

  def roll(times)
    @values = (0...times).map { rand(1..6) }
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
    @num_of_non_scoring = @values.size - score[:dice]
    score[:val]
  end
end