# frozen_string_literal: true

require 'active_support/inflector'

def convert_method(klass)
  block = lambda do
    the_self = self
    klass.new(the_self) if the_self.is_a? ::Numeric
  end
  Numeric.define_method(to_s.downcase.singularize.to_sym, block)
  Numeric.define_method(to_s.downcase.pluralize.to_sym, block)
end

##
# Abstract class for measures
class Measure
  convert_method(self)

  def initialize(number)
    raise ArgumentError, 'argument must be a number' unless number.is_a?(Numeric)

    @value = number
  end

  def value
    @value ||= 0
  end

  def +(other)
    raise ArgumentError, "Can't sum #{self.class} and #{other.class}" unless instance_of?(other.class)

    self.class.new(value + other.value)
  end

  def -(other)
    raise ArgumentError, "Can't sum #{self.class} and #{other.class}" unless instance_of?(other.class)

    self.class.new(value - other.value)
  end

  def *(other)
    unless other.is_a?(Integer) || other.is_a?(Float) || other.is_a?(Rational)
      raise ArgumentError,
            "Can't multiply #{underscored_class.pluralize} with #{other.class}"
    end

    self.class.new(Rational(@value) * other)
  end

  def /(other)
    unless other.is_a?(Numeric)
      raise ArgumentError,
            "Can't divide #{underscored_class.pluralize} with #{other.class}"
    end

    self.class.new(Rational(@value) / other)
  end

  def ==(other)
    @value == other.value
  end

  def to_s
    if @value.is_a?(Integer) && value % 10 == 1 && value % 100 != 11
      "#{@value} #{underscored_class.singularize}"
    else
      "#{@value} #{underscored_class.pluralize}"
    end
  end

  def underscored_class
    (self.class.name || '').underscore
  end
end

##
# Implements newtons
class Newton < Measure
  convert_method(self)
end

##
# Implements radians
class Radian < Measure
  convert_method(self)
end
