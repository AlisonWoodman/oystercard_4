
class Oystercard

  DEFAULT_BALANCE = 0
  LIMIT = 90
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  attr_reader :balance, :journey, :history

  def initialize(balance = 0)
    @balance = balance
    @history = []
  end

  def top_up(amount)
    fail "Maximum limit exceeded £#{LIMIT}" if amount + balance > LIMIT
    @balance += amount
  end

  def touch_in(station)
    raise "Sorry, not enough balance!" if balance < MINIMUM_FARE
    if in_journey?
      puts "Penalty fare deducted"
      deduct(PENALTY_FARE)
    end
    @journey = Journey.new
    journey.record_entry_station(station)
    @history << journey
  end

  def touch_out(station)
    if in_journey?
      deduct(MINIMUM_FARE)
      journey.record_exit_station(station)
    else
      puts "Penalty fare deducted"
      deduct(PENALTY_FARE)
    end
  end

private

  def deduct(fare)
    @balance -= fare
  end

  def in_journey?
    return false if history.empty?
    journey.in_journey?
  end
end
