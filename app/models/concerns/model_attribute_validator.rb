# frozen_string_literal: true

module ModelAttributeValidator
  extend ActiveSupport::Concern

  included do
    def self.validate_input(name, value)
      model = new(name => value)
      model.valid?
      model.errors.full_messages_for(name)
    end
  end
end
