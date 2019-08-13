# frozen_string_literal: true

class CPUThread
  attr_reader :round, :random

  def initialize(round_id)
    @round = Round.find(round_id)
    @random = RandomGaussian.new(3, 1)
  end

  def run
    10.times do
      sleep_for = sleep_duration
      sleep(sleep_for)
      # puts "play after #{sleep_for.round(2)}s!"
    end
    # puts 'end!'
  end

  private

  # Sleeps for a random amount of time, never less than 1s, never more than 7s.
  # The exact amount follows the normal/gaussian distribution.
  def sleep_duration
    random.rand.clamp(1, 7)
  end
end
