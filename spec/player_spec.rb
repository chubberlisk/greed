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
end