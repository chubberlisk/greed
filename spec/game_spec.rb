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
      it 'creates the number of players based on user input' do
        allow(STDIN).to receive(:gets).and_return('3', 'n')
        subject.main
        expect(subject.players.size).to eq(3)
      end
  
      it 'allows the number of players to be between 2 and 6' do
        num_of_players = rand(2..6)
        allow(STDIN).to receive(:gets).and_return(num_of_players.to_s, 'n')
        subject.main
        expect(subject.players.size).to eq(num_of_players)
      end
  
      it 'does not allow the number of players to be 1' do
        allow(STDIN).to receive(:gets).and_return('1', '3', 'n')
        subject.main
        expect(subject.players.size).not_to eq(1)
      end
  
      it 'does not allow the number of players to be a string' do
        allow(STDIN).to receive(:gets).and_return('hi', '3', 'n')
        subject.main
        expect(subject.players.size).not_to eq(0)
      end
    end

    context 'playing the game' do
      it 'creates a turn' do
        turn = instance_double('Turn')
        allow(STDIN).to receive(:gets).and_return('3', 'n')
        expect(Turn).to receive(:new).and_return(turn)
        expect(turn).to receive(:main)
        subject.main
      end

      it 'moves onto the next player after a turn' do
        turn = instance_double('Turn')
        allow(STDIN).to receive(:gets).and_return('3', 'y', 'y', 'y', 'n')
        expect(Turn).to receive(:new).and_return(turn).at_least(4).times
        expect(turn).to receive(:main).at_least(4).times
        subject.main
      end

      it 'asks player to continue after a turn' do
        turn = instance_double('Turn')
        allow(turn).to receive(:main)
        allow(Turn).to receive(:new).and_return(turn)
        expect(STDIN).to receive(:gets).and_return('3', 'y', 'y', 'n').at_least(3).times
        subject.main
      end

      it 'sets other players final turn to true when it is the final round' do
        turn = instance_double('Turn')
        allow(STDIN).to receive(:gets).and_return('y', 'y', 'n')
        player = Player.new(1)
        player.points = rand(3000..5000)
        subject.instance_variable_set(:@players, [player, Player.new(2), Player.new(3)])
        subject.instance_variable_set(:@final_round, true)
        subject.main
        subject.players[1..2].each { |player| expect(player.final_turn?).to be_truthy }
      end

      it 'only allows players that have not had their final turn have a turn' do
        turn = instance_double('Turn')
        allow(STDIN).to receive(:gets).and_return('y', 'n')
        player = Player.new(1)
        player.points = rand(3000..5000)
        subject.instance_variable_set(:@players, [player, Player.new(2), Player.new(3)])
        expect(Turn).to receive(:new).and_return(turn).twice
        expect(turn).to receive(:main).twice
        subject.main
      end

      # it 'sets @final_round to true when a player reaches 3000 or more points' do
      #   turn = instance_double('Turn')
      #   allow(STDIN).to receive(:gets).and_return('y')
      #   allow(turn).to receive(:main)
      #   allow(Turn).to receive(:new).and_return(turn)
      #   player = Player.new(1)
      #   player.points = rand(3000..5000)
      #   subject.instance_variable_set(:@players, [player, Player.new(2), Player.new(3)])
      #   subject.main
      #   expect(subject.final_round?).to be_truthy
      # end

      # it 'sets @end_game to true when all players have had their final turn' do
      #   turn = instance_double('Turn')
      #   allow(STDIN).to receive(:gets).and_return('y')
      #   allow(turn).to receive(:main)
      #   allow(Turn).to receive(:new).and_return(turn)
      #   players = []
      #   3.times { |i| players.push(Player.new(i + 1)) }
      #   players.each { |player| player.final_turn = true }
      #   subject.instance_variable_set(:@players, players)
      #   subject.main
      #   expect(subject.end_game?).to be_truthy
      # end
    end
  end

  describe '#players' do
    let(:players) { [Player.new(1), Player.new(2), Player.new(3)] }

    before { subject.instance_variable_set(:@players, players) }

    it 'returns an array' do
      expect(subject.players).to be_kind_of(Array)
    end

    it 'returns a set of players' do
      subject.players.each { |player| expect(player).to be_kind_of(Player) }
    end
  end

  describe '#final_round?' do
    it 'returns a boolean' do
      expect(subject.final_round?).to be(true).or be(false)
    end

    it 'returns false when initialised' do
      expect(subject.final_round?).to be(false)
    end
  end

  describe '#end_game?' do
    it 'returns a boolean' do
      expect(subject.end_game?).to be(true).or be(false)
    end

    it 'returns false when initialised' do
      expect(subject.end_game?).to be(false)
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

  describe '#highest_scorer' do
    it 'returns the player with the largest amount of points' do
      player = Player.new(2)
      player.points = 1200
      players = [Player.new(1), player, Player.new(3)]
      subject.instance_variable_set(:@players, players)
      expect(subject.highest_scorer).to eq(player)
    end
  end
end