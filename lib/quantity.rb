# frozen_string_literal: true

require_relative 'measurement_unit'
require_relative 'makeable'
require 'active_support/inflector'

MeasurementUnit.make('Newton')
##
# Makes quantities
class Quantity
  extend Makeable

  class << self
    def attrs
      @attrs ||= {}
    end

    # rubocop:disable Naming/PredicateName
    def has_unit(unit)
      return unless MeasurementUnit.any? do |other|
        unit.to_s.underscore.singularize ==
        other.to_s.underscore.singularize
      end

      @attrs ||= {}
      @attrs[:value] = unit.to_sym
    end
    # rubocop:enable Naming/PredicateName

    def add_value
      @attrs ||= {}
      @attrs[:value] ||= true # MeasurementUnit derivative or bool.
    end

    private :add_value

    def vector_value
      add_value
      @attrs[:angle] = true # Radian. Is or is not.
    end

    def scalar_value
      add_value
      @attrs[:angle] = false
    end

    def register(obj)
      @all ||= []
      @all << obj unless @all.include?(obj)
      @all
    end

    def all
      @all ||= []
    end

    def make(name = nil, &block)
      if name
        make_with_name(name) do
          Quantity.register(self)
          class_exec(&block) if block_given?
        end
      else
        Class.new(self) { class_exec(&block) if block_given? }
      end
    end
  end

  def respond_to_missing?(name)
    !!self.class.attrs[name]
  end

  def method_missing(name, *_args)
    instance_variables.any?("@#{name}") || raise(
      NoMethodError,
      "Method '#{name}' is not available." +
      instance_variables.join(', ').instance_exec do
        empty? ? '' : " Try any of #{self}"
      end
    )

    instance_variable_get("@#{name}")
  end

  def validate(key, _value)
    self.class.attrs[key.to_sym] ||
      raise(ArgumentError, "No key #{key} in #{self.class.attrs}")

    self.class.attrs[key.to_sym] == val.class.to_s.underscore.to_sym ||
      raise(ArgumentError, "Invalid value: needs to be #{self.class.attrs[key.to_sym]}")
  end

  has_unit :newton

  def initialize(opts)
    opts.each do |key, val|
      validate(key, value)

      instance_variable_set("@#{key}", val)
      self.class.define_method(key) { instance_variable_get("@#{key}") }
    end
  end
end

puts Quantity.new(value: 1.newton).value
