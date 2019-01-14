# frozen_string_literal: true

module Speed
  class Card < ::Card
    # Returns true if +card+ can be played on top of +self+.
    def can_play?(card)
      allowed_ranks = [prev.rank, succ.rank]
      allowed_ranks.include?(card.rank)
    end
  end
end
