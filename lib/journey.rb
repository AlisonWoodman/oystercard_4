class Journey

attr_reader :entry_station, :exit_station

  def initialize
    @entry_station = nil
    @exit_station = nil
  end

  def record_entry_station(station)
    @entry_station = station
  end

  def record_exit_station(station)
    @exit_station = station
  end

  def completed_journey

  end

  def in_journey?
    @entry_station != nil && exit_station == nil
  end

   def status
   end
end
