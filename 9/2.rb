require "active_support/all"

file = File.open("9/input.txt")
contents = file.read

lines = contents.split("\n")

histories = []

lines.each do |line|
  # histories << line.scan(/\d+/).map(&:to_i)
  histories << line.split(" ").map(&:to_i)
end

derivatives = histories.map.with_index do |history,i|
  derivatives = [history]
  while true do
    last_derivative = derivatives.last
    new_derivative = []
    (last_derivative.length - 1).times do |i|
      new_derivative << (last_derivative[i + 1] - last_derivative[i])
    end
    derivatives << new_derivative
    if new_derivative.uniq.count == 1 && new_derivative[0] == 0
      break
    end
    if new_derivative.length == 0
      raise "Didn't find a pattern!, history index: #{i}"
    end
  end

  # extrapolate forward, for convenience reverse the mapping
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

  # extrapolate backwards, for convenience reverse the mapping
  reversed_derivatives = derivatives.reverse
  reversed_derivatives.each.with_index do |derivative, i|
    if i == 0
      derivative.insert(0, 0)
    end

    if i == derivatives.length - 1
      break
    end

    next_derivative = reversed_derivatives[i + 1]
    next_derivative.insert(0, next_derivative.first - derivative.first)
  end

  derivatives
end

puts "sum of extrapolated forward:"
puts derivatives.map { |d| d.first.last }.sum

puts "sum of extrapolated backwards:"
puts derivatives.map { |d| d.first.first }.sum