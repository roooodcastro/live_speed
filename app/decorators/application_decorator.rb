# frozen_string_literal: true

class ApplicationDecorator
  attr_reader :object, :view

  delegate_missing_to :object

  def self.decorate(object, view_context)
    new(object, view_context)
  end

  def initialize(object, view_context)
    @object = object
    @view = view_context
  end
end
