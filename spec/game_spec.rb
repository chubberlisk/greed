require_relative '../lib/game'
require_relative '../lib/player'

describe Game do
  it 'creates a game' do
    expect(subject).not_to be_nil
  end

  describe '#main' do
    before { allow(STDOUT).to receive(:write) }  # suppress output
    
    context 'entering the number of players' do
      it 'creates number of players based on user input' do
        allow(STDIN).to receive(:gets).and_return(2)
        subject.main
        expect(subject.players.size).to eq(2)
      end
  
      it 'allows the number of players to be 2' do
        allow(STDIN).to receive(:gets).and_return(2)
        subject.main
        expect(subject.players.size).to eq(2)
      end
  
      it 'allows the number of players to be between 2 and 6' do
        num_of_players = rand(2..6)
        allow(STDIN).to receive(:gets).and_return(num_of_players)
        subject.main
        expect(subject.players.size).to eq(num_of_players)
      end
  
      it 'does not allow the number of players to be 1' do
        allow(STDIN).to receive(:gets).and_return(1, 2)
        subject.main
        expect(subject.players.size).not_to eq(1)
      end
  
      it 'does not allow the number of players to be a string' do
        allow(STDIN).to receive(:gets).and_return("hi", 2)
        subject.main
        expect(subject.players.size).not_to eq(0)
      end
    end
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