# frozen_string_literal: true

module AttributeValidator
  extend ActiveSupport::Concern

  def self.validate_attribute(name, value)
    model = self.class.new(name => value)
    model.valid?
    model.errors.full_messages_for(attr)
  end
end
