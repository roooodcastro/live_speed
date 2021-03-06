# frozen_string_literal: true

module Games
  module Speed
    class Card < ::Card
      # Returns true if +card+ can be played on top of +self+.
      def can_play?(card)
        return false unless card

        allowed_ranks = [prev.rank, succ.rank]
        allowed_ranks.include?(card.rank)
      end
    end
  end
end
