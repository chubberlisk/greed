require_relative '../lib/dice_set'

describe DiceSet do
  it 'creates a dice set' do
    expect(subject).not_to be_nil
  end

  describe '#roll' do
    before { subject.roll(5) }

    it 'returns an array' do
      expect(subject.values).to be_kind_of(Array)
    end

    it 'returns an set of integers between 1 and 6' do
      subject.values.each { |value| expect(value).to be_between(1, 6) }
    end

    it 'dice values do not change unless explicitly rolled' do
      first_time = subject.values
      second_time = subject.values
      expect(first_time).to eq(second_time)
    end

    it 'can roll different numbers of dice' do
      subject.roll(3)
      expect(subject.values.size).to eq(3)
      subject.roll(1)
      expect(subject.values.size).to eq(1)
    end
  end

  describe '#score' do
    it 'returns 0 when values is an empty list' do
      subject.instance_variable_set(:@values, [])
      expect(subject.score).to eq(0)
    end

    it 'returns 50 for a single roll of 5' do
      subject.instance_variable_set(:@values, [5])
      expect(subject.score).to eq(50)
    end

    it 'returns 100 for a single roll of 1' do
      subject.instance_variable_set(:@values, [1])
      expect(subject.score).to eq(100)
    end

    it 'returns sum of individual scores for multiple 1s and 5s' do
      subject.instance_variable_set(:@values, [1, 5, 5, 1])
      expect(subject.score).to eq(300)
    end

    it 'returns 0 for single 2s, 3s, 4s, and 6s' do
      subject.instance_variable_set(:@values, [2, 3, 4, 6])
      expect(subject.score).to eq(0)
    end

    it 'returns 1000 for a triple 1' do
      subject.instance_variable_set(:@values, [1, 1, 1])
      expect(subject.score).to eq(1000)
    end

    it 'returns 100x for other triples' do
      subject.instance_variable_set(:@values, [2, 2, 2])
      expect(subject.score).to eq(200)
      subject.instance_variable_set(:@values, [3, 3, 3])
      expect(subject.score).to eq(300)
      subject.instance_variable_set(:@values, [4, 4, 4])
      expect(subject.score).to eq(400)
      subject.instance_variable_set(:@values, [5, 5, 5])
      expect(subject.score).to eq(500)
      subject.instance_variable_set(:@values, [6, 6, 6])
      expect(subject.score).to eq(600)
    end

    it 'returns sum for mixed rolls' do
      subject.instance_variable_set(:@values, [2, 5, 2, 2, 3])
      expect(subject.score).to eq(250)
      subject.instance_variable_set(:@values, [5, 5, 5, 5])
      expect(subject.score).to eq(550)
      subject.instance_variable_set(:@values, [1, 1, 1, 1])
      expect(subject.score).to eq(1100)
      subject.instance_variable_set(:@values, [1, 1, 1, 1, 1])
      expect(subject.score).to eq(1200)
      subject.instance_variable_set(:@values, [1, 1, 1, 5, 1])
      expect(subject.score).to eq(1150)
    end

    it 'does not affect @values' do
      values = [1, 1, 1, 1]
      subject.instance_variable_set(:@values, values)
      subject.score
      expect(subject.values).to match_array(values)
    end

    it 'assigns value to @num_of_non_scoring' do
      subject.instance_variable_set(:@values, [5, 1, 3, 4, 1])
      subject.score
      expect(subject.num_of_non_scoring).to eq(2)
      subject.instance_variable_set(:@values, [1, 1, 1, 3, 1])
      subject.score
      expect(subject.num_of_non_scoring).to eq(1)
      subject.instance_variable_set(:@values, [2, 4, 4, 5, 4])
      subject.score
      expect(subject.num_of_non_scoring).to eq(1)
    end
  end
end