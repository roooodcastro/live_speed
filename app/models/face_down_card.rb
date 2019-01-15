# frozen_string_literal: true

class FaceDownCard < ::Card
  def initialize
    @suit = :'?'
    @rank = :'?'
  end

  def to_s
    return to_unicode if USE_UNICODE

    '???'
  end

  def to_h
    raise NotImplementedError
  end

  def to_unicode
    0x1F0A0.chr
  end
end
