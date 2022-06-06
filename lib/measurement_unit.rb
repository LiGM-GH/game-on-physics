# frozen_string_literal: true

require 'active_support/inflector'
require_relative 'makeable'
require_relative 'numeric_convertable'

##
# Abstract class for measurement units
class MeasurementUnit
  extend NumericConvertible
  extend Makeable

  def self.each(*_args, **_kwargs, &block)
    (@all ||= []).each(&block)
  end

  extend Enumerable

  def self.register(obj)
    @all ||= []
    @all << obj unless @all.include?(obj)
    @all
  end

  def self.make(name = nil, &block)
    if name
      make_with_name(name) do
        MeasurementUnit.register(self) # registering in measurement unit as self.class(Newton, etc)
        allow_numeric_convert
        class_exec(&block) if block_given?
      end
    else
      Class.new(self) { class_exec(&block) if block_given? }
    end
  end

  allow_numeric_convert

  def initialize(number)
    unless number.is_a?(Numeric) || number.is_a?(self.class)
      raise ArgumentError,
            "argument must be a Numeric or a #{self.class}"
    end

    @value = case number
             when self.class then number.value
             when Numeric    then number
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
    if @value.is_a?(Integer) && value == 1
      "#{@value} #{underscored_class.singularize}"
    else
      "#{@value} #{underscored_class.pluralize}"
    end
  end

  def respond_to_missing?(name, include_all)
    value.respond_to?(name, include_all)
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
