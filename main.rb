# frozen_string_literal: true

require_relative 'lib/newton'
CARET_BACK = "\33[1A"
print QUESTION = 'How many newtons do we have here? '
"#{CARET_BACK}#{(answer = gets).to_i.newtons} here!"
  .ljust(QUESTION.length + answer.length + CARET_BACK.length)
  .each_char do |char|
  print char
  sleep 0.1
end
puts
