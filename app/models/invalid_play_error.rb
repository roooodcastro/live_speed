# frozen_string_literal: true

class InvalidPlayError < StandardError
  def message
    'This play is invalid!'
  end
end