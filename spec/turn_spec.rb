require_relative '../lib/turn'
require_relative '../lib/player'

describe Turn do
  let(:player) { Player.new(1) }
  let(:turn) { Turn.new(player) }

  before { allow(STDOUT).to receive(:write) }  # suppress output

  it 'creates a turn' do
    expect(turn).not_to be_nil
  end

  [:player, :accumulated_score].each do |attribute|
    it { expect(turn).to respond_to(attribute) }
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
    it 'equals 0 when initialised' do
      expect(turn.accumulated_score).to eq(0)
    end
  end

  describe '#main' do
    it { expect(turn).to respond_to(:main) }
    
    context 'getting into the game' do
      it 'rolls 5 dice' do
        allow(DiceSet).to receive(:roll).and_return(300, 2)
        allow(STDIN).to receive(:gets).and_return('n')
        expect(DiceSet).to receive(:roll).with(5)
        turn.main
      end

      it 'adds dice set score to accumulated score if >= 300' do
        score = rand(300..1200)
        allow(DiceSet).to receive(:roll).and_return(score, 2)
        allow(STDIN).to receive(:gets).and_return('n')
        turn.main
        expect(turn.accumulated_score).to eq(score)
      end

      it 'does not add dice set score to accumulated score if < 300' do
        allow(DiceSet).to receive(:roll).and_return(rand(0...300), 2)
        turn.main
        expect(turn.accumulated_score).to eq(0)
      end

      it 'makes player in the game when dice set score is >= 300 and does not continue' do
        allow(DiceSet).to receive(:roll).and_return(rand(300..1200), 2)
        allow(STDIN).to receive(:gets).and_return('n')
        turn.main
        expect(turn.player.in_the_game?).to be_truthy
      end

      it 'keeps player not in the game when dice set score is < 300' do
        allow(DiceSet).to receive(:roll).and_return(rand(0...300), 2)
        turn.main
        expect(turn.player.in_the_game?).to be_falsey
      end

      it 'allows player to continue rolling with available dice' do
        allow(DiceSet).to receive(:roll).and_return(rand(300..1200), 2)
        allow(STDIN).to receive(:gets).and_return('y', 'n')
        expect(DiceSet).to receive(:roll).twice
        turn.main
      end

      it 'allows player to continue rolling with available dice 3 times' do
        allow(DiceSet).to receive(:roll).and_return(rand(300..1200), 2)
        allow(STDIN).to receive(:gets).and_return('y', 'y', 'n')
        expect(DiceSet).to receive(:roll).exactly(3).times
        turn.main
      end

      it 'allows player to not continue rolling' do
        allow(DiceSet).to receive(:roll).and_return(rand(300..1200), 2)
        allow(STDIN).to receive(:gets).and_return('n')
        expect(DiceSet).to receive(:roll).once
        turn.main
      end

      it 'adds accumulated score to player points if player chooses to not continue' do
        score = rand(300..1200)
        allow(DiceSet).to receive(:roll).and_return(score, 2)
        allow(STDIN).to receive(:gets).and_return('n')
        turn.main
        expect(turn.player.points).to eq(score)
      end
    end
  end
end