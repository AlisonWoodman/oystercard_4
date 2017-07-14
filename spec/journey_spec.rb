require 'journey'
require 'oystercard'

describe Journey do
  subject(:journey) { described_class.new}
  let(:loaded_oyster) {Oystercard.new(20)}
  let(:station) {double(:station)}

  it 'new instance to have an entry station' do
    expect(journey.entry_station).to be_nil
  end

  it 'new instance to have no exit station' do
    expect(journey.exit_station).to be_nil
  end

  it 'entry station is set by touching in' do
    loaded_oyster.touch_in(station)
    expect(loaded_oyster.journey.entry_station).to eq station
  end

  it 'exit station is set by touching out' do
    loaded_oyster.touch_in(station)
    loaded_oyster.touch_out(station)
    expect(loaded_oyster.journey.exit_station).to eq station
  end

  it 'records completed journey after touching out' do
    loaded_oyster.touch_in(station)
    loaded_oyster.touch_out(station)
    expect(loaded_oyster.history).to eq [loaded_oyster.journey]
  end

end
