# frozen_string_literal: true

# frozen_string_literal

module Games
  class Controller
    class << self
      private

      def array_from_h(array, klass)
        array.map do |element|
          next array_from_h(element, klass) if element.is_a?(Array)

          unsupported = !klass.respond_to?(:from_h)
          raise ArgumentError, "#{klass.name} cannot be deserialized as it does not implement #from_h" if unsupported

          klass.from_h(element)
        end
      end
    end

    def finished?; end

    private

    def array_to_h(array)
      array.map do |element|
        next array_to_h(element) if element.is_a?(Array)

        unsupported = !element.respond_to?(:to_h)
        raise ArgumentError, "#{element.class.name} cannot be serialized as it does not implement #to_h" if unsupported

        element.to_h
      end
    end
  end
end
