# frozen_string_literal: true

##
# Helps making new classes deriving from given.
# Needs make method implemented.
module Makeable
  class MakeExistingError < StandardError; end
  private

  def make_with_name(name, &block)
    Object.const_defined?(name.classify) &&
      raise(MakeExistingError,
            "Trying to make #{name.classify} which already exists")

    klass = Object.const_set(name.classify, Class.new(self))

    block_given? && klass.class_exec(&block)
  end
end
