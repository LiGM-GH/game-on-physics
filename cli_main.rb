# frozen_string_literal: true

require_relative 'lib/measure'
require_relative 'lib/measure_list'
require 'thor'
require 'active_support/inflector'

##
# Added String#measurify
class String
  def measurify
    classify.singularize
  end
end

##
# Implements CLI
class CLI < Thor
  desc 'hello', 'Say hello'
  def hello(name)
    puts "Hello #{name}"
  end

  desc 'generate TYPE NAME', 'Generates measures and quantities'
  long_desc <<~LONG_DESC
    Generates measures and quantities.
    Can process multiple type units, like
      $ \#{program_name} g measure Newton Pascal Farenheit
    generates 3 classes: Newton, Pascal and Farenheit.
  LONG_DESC

  def generate(type, *names)
    case type
    when /measure/i
      names.each { |name| generate_measure(name) }
    end
  end

  private

  def generate_measure(name)
    if Measure.all.any? { |c| c.to_s == name.measurify }
      puts "Measure #{name.measurify} already exists"
    else
      measure_list_path = 'lib/measure_list.rb'

      File.open(measure_list_path, 'r+') do |file|
        file.getc until file.eof?
        file.puts "Measure.make('#{name.measurify}')"
      end
    end
  end
end

CLI.start(ARGV)
