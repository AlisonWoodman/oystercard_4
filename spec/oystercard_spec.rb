require 'oystercard'

describe Oystercard do

  subject(:oyster) { described_class.new }
  let(:loaded_oyster) { described_class.new(90) }
  let(:amount) { 50 }
  let (:fare) { 2 }
  let(:entrance) { "bank" }
  let(:exit_st) { "aldgate" }
  let(:my_journey) {{entry_station: entrance, exit_station: exit_st}}

  context '#initialize' do
    it 'has balance of 0' do
      expect(oyster.balance).to eq(described_class::DEFAULT_BALANCE)
    end

    it 'is initially not in a journey' do
      expect(oyster).not_to be_in_journey
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
     maximum_balance = Oystercard::LIMIT
     expect{ loaded_oyster.top_up(amount)}.to raise_error "Maximum limit exceeded £#{maximum_balance}"
   end
 end

  context 'station state' do

   it 'touches in card' do
     loaded_oyster.touch_in(entrance)
     expect(loaded_oyster).to be_in_journey
   end

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
       loaded_oyster.touch_out(exit_st)
     end

     it 'touches out card' do
       expect(loaded_oyster).not_to be_in_journey
     end

     it 'checks that a charge is made on touch out' do
       expect{ loaded_oyster.touch_out(exit_st) }.to change {loaded_oyster.balance}.by (-described_class::MINIMUM_FARE)
     end

    #  it 'checks that after touching in and out creates a journey' do
    #   expect(loaded_oyster.history.last).to eq
    # end
   end
end
