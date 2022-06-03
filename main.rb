# frozen_string_literal: true

require_relative 'lib/measure'
require_relative 'lib/measure_list'

CARET_BACK = "\33[1A"
QUESTION = 'How many newtons do we have here? '

if __FILE__ == $PROGRAM_NAME
  if ARGV.size == 1
    puts "We have #{ARGV[0].to_r.newtons} here."
  else
    answer = 'Non-empty string'
    loop do
      print QUESTION
      break if (answer = gets.chomp.strip).empty?

      puts "#{answer.to_r.newtons} here!"
        .ljust(QUESTION.length + answer.length + CARET_BACK.length)
    end
  end
end
