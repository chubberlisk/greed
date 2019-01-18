require_relative '../lib/player'

describe Player do
  subject { Player.new(1) }

  it 'creates a player' do
    expect(subject).not_to be_nil
  end

  [:number, :points, :in_the_game?, :final_turn?].each do |get_method|
    it { expect(subject).to respond_to(get_method) }
  end

  [:points=, :in_the_game=, :final_turn=].each do |set_method|
    it { expect(subject).to respond_to(set_method) }
  end

  describe '#number' do
    it 'returns an integer' do
      expect(subject.number).to be_kind_of(Integer)
    end
  end

  describe '#points' do
    it 'returns 0 when initialised' do
      expect(subject.points).to eq(0)
    end

    it 'returns 100 when set to 100' do
      subject.points = 100
      expect(subject.points).to eq(100)
    end
  end

  describe '#in_the_game?' do
    it 'returns false when initialised' do
      expect(subject.in_the_game?).to be_falsey
    end

    it 'returns false when their points is less than 300' do
      subject.points = rand(0...300)
      expect(subject.in_the_game?).to be_falsey
    end

    it 'returns true when their points is equal to 300' do
      subject.points = 300
      expect(subject.in_the_game?).to be_truthy
    end

    it 'returns true when their points is more than 300' do
      subject.points = rand(300..3000)
      expect(subject.in_the_game?).to be_truthy
    end
  end

  describe '#final_turn?' do
    it 'returns false when initialised' do
      expect(subject.final_turn?).to be_falsey
    end

    it 'returns false when their points is less than 3000' do
      subject.points = rand(0...3000)
      expect(subject.final_turn?).to be_falsey
    end

    it 'returns true when their points is equal to 3000' do
      subject.points = 3000
      expect(subject.final_turn?).to be_truthy
    end

    it 'returns true when their points is more than 3000' do
      subject.points = rand(3000..5000)
      expect(subject.final_turn?).to be_truthy
    end
  end
end