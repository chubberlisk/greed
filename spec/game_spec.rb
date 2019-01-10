require_relative '../lib/game'
require_relative '../lib/player'

describe Game do
  it 'creates a game' do
    expect(subject).not_to be_nil
  end

  describe '#players' do
    let(:players) { [Player.new, Player.new] }

    before { subject.instance_variable_set(:@players, players) }

    it 'returns an array' do
      expect(subject.players).to be_kind_of(Array)
    end

    it 'returns a set of players' do
      subject.players.each { |player| expect(player).to be_kind_of(Player) }
    end
  end

  describe '#end_game' do
    it 'returns a boolean' do
      expect(subject.end_game).to be(true).or be(false)
    end

    it 'returns false when initialised' do
      expect(subject.end_game).to be(false)
    end
  end
end