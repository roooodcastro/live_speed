# frozen_string_literal: true

class ApplicationSerializer
  attr_reader :record

  def self.from_collection_as_json(collection)
    collection.map { |record| new(record).as_json }
  end

  def initialize(record)
    @record = record
  end

  def as_json
    raise NotImplementedError
  end
end
