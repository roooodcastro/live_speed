# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  default_scope -> { order(created_at: :asc) }

  def self.rescued_transaction(opts = {})
    result = nil
    transaction(opts) do
      result = yield
    end
    result
  rescue ActiveRecord::RecordInvalid
    nil
  end

  def error_messages
    errors.messages.values.flatten.join(', ')
  end
end
