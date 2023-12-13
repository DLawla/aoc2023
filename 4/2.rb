file = File.open("4/input.txt")
contents = file.read

lines = contents.split("\n")

cards = lines.map.with_index do |line, i|
  numbers = line.split(": ")[1]
  winning_numbers = numbers.split(" | ").first.scan(/\d+/)
  owned_numbers = numbers.split(" | ")[1].scan(/\d+/)

  {winning_numbers: winning_numbers, owned_numbers: owned_numbers}

  winning_count = owned_numbers.select do |owned_number|
    winning_numbers.include?(owned_number)
  end.count

  {no: i + 1, winning_count:, number_held: 1}
end

cards.length.times do |i|
  card = cards[i]

  card[:winning_count].times do |j|
    cards[i + j + 1][:number_held] += card[:number_held]
  end
end

puts cards.map { |card| card[:number_held] }.sum