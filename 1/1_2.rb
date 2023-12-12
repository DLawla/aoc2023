file = File.open("1/input.txt")
contents = file.read

lines = contents.split("\n")

string_numbers = ["_", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

def all_matching_indices(string, text)
  indices = []
  index = string.index(text)
  while index
    indices << index
    index = string.index(text, index + 1)
  end
  indices
end

all_numbers = lines.map do |line|
  numbers = line.chars.map.with_index do |char, i|
    found_string = string_numbers.find do |string_number|
      all_matching_indices(line, string_number).include?(i)
    end

    if found_string
      string_numbers.index(found_string)
    else
      char =~ /\d/ ? char.to_i : nil
    end
  end.compact

  result = if (numbers.length == 1)
    "#{numbers.first}#{numbers.first}".to_i
  else
    "#{numbers.first}#{numbers.last}".to_i
  end
  result
end

puts all_numbers.sum
