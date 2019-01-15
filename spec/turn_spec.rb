require_relative '../lib/turn'
require_relative '../lib/player'

describe Turn do
  let(:player) { Player.new(1) }
  let(:turn) { Turn.new(player) }

  before { allow(STDOUT).to receive(:write) }  # suppress output

  it 'creates a turn' do
    expect(turn).not_to be_nil
  end

  [:player, :accumulated_score, :end].each do |attribute|
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

  describe '#end' do
    it 'is false when initialised' do
      expect(turn.end).to be_falsey
    end
  end

  describe '#main' do
    it { expect(turn).to respond_to(:main) }
    
    context 'player is not in the game' do
      it 'rolls 5 dice' do
        dice_set = instance_double('DiceSet', values: [3, 3, 3, 4, 6], score: 300)
        allow(DiceSet).to receive(:new).and_return(dice_set)
        expect(dice_set).to receive(:roll).with(5)
        turn.main
      end

      it 'adds dice set score to accumulated score if >= 300' do
        dice_set = instance_double('DiceSet', values: [3, 3, 3, 4, 6], score: rand(300..1000))
        allow(dice_set).to receive(:roll).with(5)
        allow(DiceSet).to receive(:new).and_return(dice_set)
        turn.main
        expect(turn.accumulated_score).to eq(dice_set.score)
      end

      it 'does not add dice set score to accumulated score if < 300' do
        dice_set = instance_double('DiceSet', values: [3, 3, 3, 4, 6], score: rand(0...300))
        allow(dice_set).to receive(:roll).with(5)
        allow(DiceSet).to receive(:new).and_return(dice_set)
        turn.main
        expect(turn.accumulated_score).to eq(0)
      end

      it 'makes player in the game when dice set score is >= 300' do
        dice_set = instance_double('DiceSet', values: [3, 3, 3, 4, 6], score: rand(300..1000))
        allow(dice_set).to receive(:roll).with(5)
        allow(DiceSet).to receive(:new).and_return(dice_set)
        turn.main
        expect(turn.player.in_the_game?).to be_truthy
      end

      it 'keeps player not in the game when dice set score is < 300' do
        dice_set = instance_double('DiceSet', values: [3, 3, 3, 4, 6], score: rand(0...300))
        allow(dice_set).to receive(:roll).with(5)
        allow(DiceSet).to receive(:new).and_return(dice_set)
        turn.main
        expect(turn.player.in_the_game?).to be_falsey
      end
    end
  end
end