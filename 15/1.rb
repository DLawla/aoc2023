file = File.open("15/input.txt")
contents = file.read

words = contents.split(",")

values = words.map do |word|
  current_value = 0
  word.chars.each do |char|
    ascii_code = char.ord
    current_value += ascii_code
    current_value = current_value * 17
    current_value = current_value % 256
  end
  current_value
end
puts values.sum
# puts all_numbers.sum