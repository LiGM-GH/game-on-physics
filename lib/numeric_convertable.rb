# frozen_string_literal: true

##
# Dynamically add methods to Numeric
# When numeric convert allowed, implements these methods:
# - 5.numeric_convertable_unit
# - 4.numeric_convertable_units
module NumericConvertible
  # @return [Array(Class)]
  attr_reader :all

  def allow_numeric_convert
    klass = self

    block = lambda do
      value = self
      klass.new(value) if value.is_a? ::Numeric
    end

    Numeric.define_method(klass.to_s.underscore.singularize.to_sym, &block)
    Numeric.define_method(klass.to_s.underscore.pluralize.to_sym,   &block)
  end
end
