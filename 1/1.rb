file = File.open("1/input.txt")
contents = file.read

lines = contents.split("\n")

all_numbers = lines.map do |line|
  numbers = line.chars.select { |char| char =~ /\d/ }

  if numbers.length == 1
    "#{numbers.first}#{numbers.first}".to_i
  else
    "#{numbers.first}#{numbers.last}".to_i
  end
end

puts all_numbers.sum