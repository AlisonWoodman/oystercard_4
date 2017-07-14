require 'oystercard'

describe Oystercard do

  subject(:oyster)       { described_class.new }
  let(:loaded_oyster)    { described_class.new(90) }
  let(:amount)           { 50 }
  let (:fare)            { 2 }
  let(:default_balance)  { described_class::DEFAULT_BALANCE }
  let(:penalty_fare)     { described_class::PENALTY_FARE }
  let(:minimum_fare)     { described_class::MINIMUM_FARE }
  let(:maximum_balance)  { described_class::LIMIT }
  let(:entrance)         { "bank" }
  let(:exit_st)          { "aldgate" }
  let(:my_journey)       {{entry_station: entrance, exit_station: exit_st}}

  context '#initialize' do
    it 'has balance of 0' do
      expect(oyster.balance).to eq(default_balance)
    end

    it 'checks that the card has en empty list of journeys by default' do
      expect(oyster.history).to be_empty
    end
  end

  context '#top_up' do
    it 'top up to balance' do
      expect{oyster.top_up(amount)}.to change { oyster.balance }.by(amount)
  end

   it 'limits balance to 90' do
     expect{ loaded_oyster.top_up(amount)}.to raise_error "Maximum limit exceeded £#{maximum_balance}"
   end
 end

  context 'station state' do

   it 'does not allow to touch in if balance is less than minimum fare' do
     expect{ oyster.touch_in(entrance) }.to raise_error("Sorry, not enough balance!")
   end
 end

   context "#touch_in" do

    it "remember the entry station after the touch in" do
      loaded_oyster.touch_in(entrance)
      expect(loaded_oyster.history[0].entry_station).to eq entrance
    end
  end

   context '#touch_out' do
     before (:each) do
       loaded_oyster.touch_in(entrance)
     end

     it 'checks that a charge is made on touch out' do
       expect{ loaded_oyster.touch_out(exit_st) }.to change {loaded_oyster.balance}.by (-minimum_fare)
     end

    #  it 'checks that after touching in and out creates a journey' do
    #   expect(loaded_oyster.history.last).to eq
    # end
   end

   context 'edge cases' do
     it 'charges a penalty fare when touching out without an entry station' do
       expect{ loaded_oyster.touch_out(exit_st) }.to change {loaded_oyster.balance}.by -penalty_fare
     end

     it 'charges a penalty fare when touching in twice' do
       loaded_oyster.touch_in(entrance)
       expect { loaded_oyster.touch_in(entrance) }.to change {loaded_oyster.balance}.by -penalty_fare
     end
   end
end
