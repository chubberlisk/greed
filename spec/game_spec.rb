require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/turn'

describe Game do
  it 'creates a game' do
    expect(subject).not_to be_nil
  end

  describe '#main' do
    before { allow(STDOUT).to receive(:write) }  # suppress output
    
    context 'entering the number of players' do
      # before { allow(subject).to receive(:end_game).and_return(true) }

      it 'creates the number of players based on user input' do
        allow(STDIN).to receive(:gets).and_return('2')
        subject.main
        expect(subject.players.size).to eq(2)
      end
  
      it 'allows the number of players to be 2' do
        allow(STDIN).to receive(:gets).and_return('2')
        subject.main
        expect(subject.players.size).to eq(2)
      end
  
      it 'allows the number of players to be between 2 and 6' do
        num_of_players = rand(2..6)
        allow(STDIN).to receive(:gets).and_return(num_of_players.to_s)
        subject.main
        expect(subject.players.size).to eq(num_of_players)
      end
  
      it 'does not allow the number of players to be 1' do
        allow(STDIN).to receive(:gets).and_return('1', '2')
        subject.main
        expect(subject.players.size).not_to eq(1)
      end
  
      it 'does not allow the number of players to be a string' do
        allow(STDIN).to receive(:gets).and_return('hi', '2')
        subject.main
        expect(subject.players.size).not_to eq(0)
      end
    end

    context 'playing the game' do
      it 'creates a turn' do
        turn = instance_double('Turn')
        allow(STDIN).to receive(:gets).and_return('2')
        expect(Turn).to receive(:new).and_return(turn).at_least(:once)
        expect(turn).to receive(:main).at_least(:once)
        subject.main
      end
    end
  end

  describe '#players' do
    let(:players) { [Player.new(1), Player.new(2)] }

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

  describe '#turn' do
    it 'returns 1 when initialised' do
      expect(subject.turn).to eq(1)
    end
  end

  describe '#turn_player' do
    let(:players) { [Player.new(1), Player.new(2)] }

    before { subject.instance_variable_set(:@players, players) }

    it 'returns the first player for the first turn' do
      expect(subject.turn_player).to eq(players[0])
    end

    it 'returns the second player for the second turn' do
      subject.instance_variable_set(:@turn, 2)
      expect(subject.turn_player).to eq(players[1])
    end
  end

  describe '#players_in_the_game' do
    it 'returns an empty list when initialised' do
      expect(subject.players_in_the_game).to eq([])
    end

    it 'returns an array of player objects that are in the game' do
      player_in_the_game = Player.new(1)
      player_in_the_game.instance_variable_set(:@in_the_game, player_in_the_game)
      players = [player_in_the_game, Player.new(2), Player.new(3)]
      subject.instance_variable_set(:@players, players)
      expect(subject.players_in_the_game).to eq([player_in_the_game])
    end
  end
end