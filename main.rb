# frozen_string_literal: true

require_relative 'lib/newton'
CARET_BACK = "\33[1A"
QUESTION = 'How many newtons do we have here? '

if __FILE__ == $PROGRAM_NAME
  if ARGV.size == 1
    puts "We have #{ARGV[0].to_r.newtons} here."
  else
    loop do
      print QUESTION
      puts "#{(answer = gets.chomp).to_r.newtons} here!"
        .ljust(QUESTION.length + answer.length + CARET_BACK.length)
      break if answer.empty?
    end
  end
end
