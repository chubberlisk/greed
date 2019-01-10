require_relative '../lib/game'
require_relative '../lib/player'

describe Game do
  let(:players) { [Player.new, Player.new] }
  let(:game) { Game.new(players) }

  it 'creates a game' do
    expect(game).not_to be_nil
  end

  describe '#players' do
    it 'returns an array' do
      expect(game.players).to be_kind_of(Array)
    end

    it 'returns an set of players' do
      game.players.each { |player| expect(player).to be_kind_of(Player) }
    end
  end

  describe '#end_game' do
    it 'returns a boolean' do
      expect(game.end_game).to be(true).or be(false)
    end

    it 'returns false when initialised' do
      expect(game.end_game).to be(false)
    end
  end
end