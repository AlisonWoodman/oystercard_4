require 'journey'
require 'oystercard'

describe Journey do
  subject(:journey) { described_class.new}
  let(:loaded_oyster) {Oystercard.new(20)}

  it "new instance to have an entry station" do
    expect(journey.entry_station).to be_nil
  end

  it "new instance to have no exit station" do
    expect(journey.exit_station).to be_nil
  end

it "entry station is set by touching in" do
  loaded_oyster.touch_in('bank')
  expect(loaded_oyster.journey.entry_station).to eq 'bank'
end

end
