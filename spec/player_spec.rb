require_relative '../lib/player'

describe Player do
  it 'creates a player' do
    expect(subject).not_to be_nil
  end

  describe '#points' do
    it 'returns 0 when initialised' do
      expect(subject.points).to eq(0)
    end

    it 'returns 100 when changed' do
      subject.points = 100
      expect(subject.points).to eq(100)
    end
  end

  describe '#in_the_game' do
    it 'returns false when initialised' do
      expect(subject.in_the_game).to be_falsey
    end

    it 'returns true when their points is equal to 300' do
      subject.points = 300
      expect(subject.in_the_game).to be_truthy
    end

    it 'returns true when their points is more than 300' do
      subject.points = rand(300..3000)
      expect(subject.in_the_game).to be_truthy
    end
  end
end