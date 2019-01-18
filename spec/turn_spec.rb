require_relative '../lib/turn'
require_relative '../lib/player'

describe Turn do
  let(:player) { Player.new(1) }
  let(:turn) { Turn.new(player) }

  before { allow(STDOUT).to receive(:write) }  # suppress output

  it 'creates a turn' do
    expect(turn).not_to be_nil
  end

  [:player, :accumulated_score].each do |get_method|
    it { expect(turn).to respond_to(get_method) }
  end

  describe '#player' do
    it 'cannot be nil when initialised' do
      expect(turn.player).not_to be_nil
    end
    
    it 'returns a Player object' do
      expect(turn.player).to be_kind_of(Player) 
    end
  end

  describe '#accumulated_score' do
    it 'returns 0 when initialised' do
      expect(turn.accumulated_score).to eq(0)
    end
  end

  describe '#main' do
    it { expect(turn).to respond_to(:main) }
    
    context 'not the game' do
      it 'rolls 5 dice' do
        allow(DiceSet).to receive(:roll).and_return([0, 0])
        expect(DiceSet).to receive(:roll).with(5).once
        turn.main
      end

      it 'adds dice set score to accumulated score if equal to 300' do
        score = 300
        allow(DiceSet).to receive(:roll).and_return([score, 2])
        allow(STDIN).to receive(:gets).and_return('n')
        turn.main
        expect(turn.accumulated_score).to eq(score)
      end

      it 'adds dice set score to accumulated score if more than 300' do
        score = rand(300..1200)
        allow(DiceSet).to receive(:roll).and_return([score, 2])
        allow(STDIN).to receive(:gets).and_return('n')
        turn.main
        expect(turn.accumulated_score).to eq(score)
      end

      it 'does not add dice set score to accumulated score if less than 300' do
        allow(DiceSet).to receive(:roll).and_return([rand(0...300), 2])
        turn.main
        expect(turn.accumulated_score).to eq(0)
      end

      it 'allows player, after scoring, to continue rolling with available dice' do
        allow(DiceSet).to receive(:roll).and_return([rand(300..1200), 2])
        allow(STDIN).to receive(:gets).and_return('y', 'n')
        expect(DiceSet).to receive(:roll).with(5).once
        expect(DiceSet).to receive(:roll).with(2).once
        turn.main
      end

      it 'allows player, after scoring, to continue rolling with available dice 3 times' do
        allow(DiceSet).to receive(:roll).and_return([rand(300..1200), 2], [100, 1])
        allow(STDIN).to receive(:gets).and_return('y', 'y', 'n')
        expect(DiceSet).to receive(:roll).with(5).once
        expect(DiceSet).to receive(:roll).with(2).once
        expect(DiceSet).to receive(:roll).with(1).once
        turn.main
      end

      it 'allows player, after scoring, to not continue rolling' do
        allow(DiceSet).to receive(:roll).and_return([rand(300..1200), 2])
        allow(STDIN).to receive(:gets).and_return('n')
        expect(DiceSet).to receive(:roll).once
        turn.main
      end

      it 'adds accumulated score to player points if player chooses to not continue' do
        score = rand(300..1200)
        allow(DiceSet).to receive(:roll).and_return([score, 2])
        allow(STDIN).to receive(:gets).and_return('n')
        turn.main
        expect(turn.player.points).to eq(score)
      end
    end
  end

  context 'in the game' do
    before { turn.player.points = 300 }

    it 'adds dice set score to accumulated score if more than 0' do
      score = 100
      allow(DiceSet).to receive(:roll).and_return([score, 4])
      allow(STDIN).to receive(:gets).and_return('n')
      turn.main
      expect(turn.accumulated_score).to eq(score)
    end

    it 'does not add dice set score to accumulated score if equal to 0' do
      allow(DiceSet).to receive(:roll).and_return([0, 0])
      turn.main
      expect(turn.accumulated_score).to eq(0)
    end

    it 'allows player, after scoring, to continue rolling with available dice' do
      allow(DiceSet).to receive(:roll).and_return([100, 4])
      allow(STDIN).to receive(:gets).and_return('y', 'n')
      expect(DiceSet).to receive(:roll).with(5).once
      expect(DiceSet).to receive(:roll).with(4).once
      turn.main
    end

    it 'allows player, after scoring, to not continue rolling' do
      allow(DiceSet).to receive(:roll).and_return([100, 4])
      allow(STDIN).to receive(:gets).and_return('n')
      expect(DiceSet).to receive(:roll).once
      turn.main
    end

    it 'adds accumulated score to player points if player chooses to not continue' do
      current_player_points = turn.player.points
      score = 100
      allow(DiceSet).to receive(:roll).and_return([score, 4])
      allow(STDIN).to receive(:gets).and_return('n')
      turn.main
      expect(turn.player.points).to eq(current_player_points + score)
    end
  end
end