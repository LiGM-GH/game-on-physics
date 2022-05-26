# frozen_string_literal: true

require_relative 'lib/newton'
CARET_BACK = "\33[1A"
print QUESTION = 'How many newtons do we have here? '
puts "#{(answer = gets.chomp).to_r.newtons} here!"
  .ljust(QUESTION.length + answer.length + CARET_BACK.length)
