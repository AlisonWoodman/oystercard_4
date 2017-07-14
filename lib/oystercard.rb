
class Oystercard

  DEFAULT_BALANCE = 0
  LIMIT = 90
  MINIMUM_FARE = 1

  attr_reader :balance, :journey, :history

  def initialize(balance = 0)
    @balance = balance
    @history = []
  end

  def top_up(amount)
    fail "Maximum limit exceeded £#{LIMIT}" if amount + balance > LIMIT
    @balance += amount
  end

  def in_journey?
    if @history.empty?
      false
    else
      journey.in_journey?
    end
  end

  def touch_in(station)
    raise "Sorry, not enough balance!" if balance < MINIMUM_FARE
    @journey = Journey.new
    journey.record_entry_station(station)
    @history << journey
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    journey.record_exit_station(station)
  end

private

def deduct(fare)
  @balance -= fare
end

end
