# frozen_string_literal: true

require 'active_support/inflector'

##
# Abstract class for measures
class Measure
  def self.allow_numeric_convert
    # @type var klass: singleton(Measure)
    klass = self
    block = lambda do
      value = self
      klass.new(value) if value.is_a? ::Numeric
    end
    Numeric.define_method(to_s.downcase.singularize.to_sym, block)
    Numeric.define_method(to_s.downcase.pluralize.to_sym, block)
  end

  allow_numeric_convert

  def initialize(number)
    unless number.is_a?(Numeric) || number.is_a?(self.class)
      raise ArgumentError,
            "argument must be a Numeric or a #{self.class}"
    end

    @value = case number
             when self.class
               number.value
             when Numeric
               number
             end
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
    raise ArgumentError, "Method not implemented: #{self.class} == #{other.class}" unless instance_of?(other.class)

    @value == other.value
  end

  def to_s
    # // FOR RUSSIAN % 10 == 1 && value % 100 != 11
    if @value.is_a?(Integer) && value == 1
      "#{@value} #{underscored_class.singularize}"
    else
      "#{@value} #{underscored_class.pluralize}"
    end
  end

  def respond_to_missing?(*args)
    value.respond_to?(*args)
  end

  def method_missing(name, *args, **kwargs, &block)
    value.send(name, *args, **kwargs, &block).yield_self do |val|
      val.is_a?(Numeric) ? val.newtons : val
    end
  end

  private

  def underscored_class
    (self.class.name || '').underscore
  end
end

##
# Implements newtons
class Newton < Measure
  allow_numeric_convert
end

##
# Implements radians
class Radian < Measure
  allow_numeric_convert
end
