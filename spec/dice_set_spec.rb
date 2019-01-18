require_relative '../lib/dice_set'

describe DiceSet do
  before { allow(STDOUT).to receive(:write) }  # suppress output

  describe '.roll' do
    it 'returns two values' do
      expect(DiceSet.roll(5).size).to eq(2) 
    end

    it 'returns two integers' do
      DiceSet.roll(5).each { |value| expect(value).to be_kind_of(Integer) }
    end

    it 'rolls different number of dice' do
      DiceSet.roll(3)
      expect(DiceSet.class_variable_get(:@@values).size).to eq(3)
      DiceSet.roll(1)
      expect(DiceSet.class_variable_get(:@@values).size).to eq(1)
    end
  end

  describe '.score' do
    it 'returns 0 when values is an empty list' do
      DiceSet.class_variable_set(:@@values, [])
      expect(DiceSet.score[:val]).to eq(0)
    end

    it 'returns 50 for a single roll of 5' do
      DiceSet.class_variable_set(:@@values, [5])
      expect(DiceSet.score[:val]).to eq(50)
    end

    it 'returns 100 for a single roll of 1' do
      DiceSet.class_variable_set(:@@values, [1])
      expect(DiceSet.score[:val]).to eq(100)
    end

    it 'returns sum of individual scores for multiple 1s and 5s' do
      DiceSet.class_variable_set(:@@values, [1, 5, 5, 1])
      expect(DiceSet.score[:val]).to eq(300)
    end

    it 'returns 0 for single 2s, 3s, 4s, and 6s' do
      DiceSet.class_variable_set(:@@values, [2, 3, 4, 6])
      expect(DiceSet.score[:val]).to eq(0)
    end

    it 'returns 1000 for a triple 1' do
      DiceSet.class_variable_set(:@@values, [1, 1, 1])
      expect(DiceSet.score[:val]).to eq(1000)
    end

    it 'returns 100x for other triples' do
      DiceSet.class_variable_set(:@@values, [2, 2, 2])
      expect(DiceSet.score[:val]).to eq(200)
      DiceSet.class_variable_set(:@@values, [3, 3, 3])
      expect(DiceSet.score[:val]).to eq(300)
      DiceSet.class_variable_set(:@@values, [4, 4, 4])
      expect(DiceSet.score[:val]).to eq(400)
      DiceSet.class_variable_set(:@@values, [5, 5, 5])
      expect(DiceSet.score[:val]).to eq(500)
      DiceSet.class_variable_set(:@@values, [6, 6, 6])
      expect(DiceSet.score[:val]).to eq(600)
    end

    it 'returns sum for mixed rolls' do
      DiceSet.class_variable_set(:@@values, [2, 5, 2, 2, 3])
      expect(DiceSet.score[:val]).to eq(250)
      DiceSet.class_variable_set(:@@values, [5, 5, 5, 5])
      expect(DiceSet.score[:val]).to eq(550)
      DiceSet.class_variable_set(:@@values, [1, 1, 1, 1])
      expect(DiceSet.score[:val]).to eq(1100)
      DiceSet.class_variable_set(:@@values, [1, 1, 1, 1, 1])
      expect(DiceSet.score[:val]).to eq(1200)
      DiceSet.class_variable_set(:@@values, [1, 1, 1, 5, 1])
      expect(DiceSet.score[:val]).to eq(1150)
    end

    it 'does not affect @@values' do
      values = [1, 1, 1, 1]
      DiceSet.class_variable_set(:@@values, values)
      DiceSet.score
      expect(DiceSet.class_variable_get(:@@values)).to match_array(values)
    end
  end

  describe '.num_of_available_dice' do
    it 'returns 0 when all non-scoring dice' do
      DiceSet.class_variable_set(:@@values, [2, 3, 4, 4, 6])
      expect(DiceSet.num_of_available_dice).to eq(0)
    end

    it 'returns 2 when 2 non-scoring dice' do
      DiceSet.class_variable_set(:@@values, [5, 1, 3, 4, 1])
      expect(DiceSet.num_of_available_dice).to eq(2)
    end

    it 'returns 1 when 1 non-scoring dice' do
      DiceSet.class_variable_set(:@@values, [1, 1, 1, 3, 1])
      expect(DiceSet.num_of_available_dice).to eq(1)
    end

    it 'returns 5 when all 5 scoring dice' do
      DiceSet.class_variable_set(:@@values, [1, 1, 1, 1, 1])
      expect(DiceSet.num_of_available_dice).to eq(5)
    end

    it 'returns 5 when all 3 scoring dice' do
      DiceSet.class_variable_set(:@@values, [1, 1, 1])
      expect(DiceSet.num_of_available_dice).to eq(5)
    end
  end
end