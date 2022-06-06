# frozen_string_literal: true

require_relative 'lib/measurement_unit'
require_relative 'lib/unit_list'
require 'thor'
require 'active_support/inflector'

##
# Implements CLI
class CLI < Thor
  desc 'hello', 'Say hello'
  def hello(name)
    puts "Hello #{name}"
  end

  desc 'generate TYPE NAME', 'Generates measurement units and quantities'
  long_desc <<~LONG_DESC
    Generates measurement units and quantities.\n
      $ \#{program_name} g unit UNIT\n
      NOW NOT IMPLEMENTED $ \#{program_name} g quantity QUANTITY\n
    Can process multiple type units, like
      $ \#{program_name} g unit Newton Pascal Farenheit
    generates 3 classes: Newton, Pascal and Farenheit.
  LONG_DESC

  def generate(type, *names)
    case type
    when /unit/i
      names.each { |name| generate_measurement_unit(name) }
    else
      puts "Unknown type: #{type}. Look help"
    end
  end

  private

  # @param [String] str
  # @return [String]
  def measure_like(str)
    str.classify.singularize
  end

  def generate_measurement_unit(name)
    if MeasurementUnit.all.any? { |c| c.to_s == measure_like(name) }
      puts "Measurement unit #{measure_like(name)} already exists"
    else
      unit_list_path = 'lib/unit_list.rb'

      File.open(unit_list_path, 'r+') do |file|
        file.getc until file.eof?
        file.puts "MeasurementUnit.make('#{measure_like(name)}')"
      end
    end
  end
end

CLI.start(ARGV)
