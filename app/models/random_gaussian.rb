# frozen_string_literal: true

class RandomGaussian
  attr_reader :next_number, :valid, :standard_deviation, :mean

  def initialize(mean, standard_deviation)
    @mean = mean
    @standard_deviation = standard_deviation
    @valid = false
    @next_number = 0
  end

  def rand
    if valid
      @valid = false
      next_number
    else
      @valid = true
      x, y = self.class.gaussian(mean, standard_deviation)
      @next_number = y
      x
    end
  end

  def self.gaussian(mean, standard_deviation)
    theta = 2 * Math::PI * Kernel.rand
    scale = standard_deviation * rho
    x = mean + scale * Math.cos(theta)
    y = mean + scale * Math.sin(theta)
    [x, y]
  end

  def self.rho
    Math.sqrt(-2 * Math.log(1 - Kernel.rand))
  end
end
