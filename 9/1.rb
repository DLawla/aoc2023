require "active_support/all"

file = File.open("9/test.txt")
contents = file.read

lines = contents.split("\n")

histories = []

lines.each do |line|
  histories << line.scan(/\d+/).map(&:to_i)
end

predicted_values = histories.map do |history|
  derivatives = [history]

  while true do
    last_derivative = derivatives.last
    new_derivative = []
    (last_derivative.length - 1).times do |i|
      new_derivative << last_derivative[i + 1] - last_derivative[i]
    end
    derivatives << new_derivative
    if new_derivative.uniq.count == 1 && new_derivative[0] == 0
      break
    end
  end

  # work backwards
  reversed_derivatives = derivatives.reverse
  reversed_derivatives.each.with_index do |derivative, i|
    if i == 0
      derivative << 0
    end

    if i == derivatives.length - 1
      break
    end

    next_derivative = reversed_derivatives[i + 1]
    next_derivative << derivative.last + next_derivative.last
  end
  derivatives.first.last
end

puts predicted_values
puts "sum:"
puts predicted_values.sum