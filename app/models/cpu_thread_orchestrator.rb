# frozen_string_literal: true

class CpuThreadOrchestrator
  include Singleton

  attr_reader :thread

  def initialize
    restart
  end

  def ensure_is_running
    restart unless thread&.alive?
  end

  def stop
    thread&.kill
  end

  private

  def restart
    stop
    @thread = Thread.new { CPUThread.new.run }
  end
end
