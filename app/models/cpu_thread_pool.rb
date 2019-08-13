# frozen_string_literal: true

class CPUThreadPool
  include Singleton

  def initialize
    self.threads = {}
  end

  def thread_for(round_id)
    threads[round_id] || create_thread_for(round_id)
  end

  def end_thread_for(round_id)
    thread = thread_for(round_id)
    return unless thread

    Thread.kill(thread)
    threads.delete(round_id)
  end

  private

  attr_accessor :threads

  def create_thread_for(round_id)
    threads[round_id] = Thread.new { CPUThread.new(round_id).run }
  end
end
