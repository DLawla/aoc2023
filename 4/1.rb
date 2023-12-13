file = File.open("4/input.txt")
contents = file.read

lines = contents.split("\n")

cards = lines.map do |line|
  numbers = line.split(": ")[1]
  winning_numbers = numbers.split(" | ").first.scan(/\d+/)
  owned_numbers = numbers.split(" | ")[1].scan(/\d+/)

  {winning_numbers: winning_numbers, owned_numbers: owned_numbers}
end

points = cards.map do |card|
  count = card[:owned_numbers].select do |owned_number|
    card[:winning_numbers].include?(owned_number)
  end.count

  if count == 0
    0
  else
    2 ** (count - 1)
  end
end

puts points.sum
# puts all_numbers.sum