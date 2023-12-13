# open file names test.txt in current directory
file = File.open("3/input.txt")
contents = file.read

lines = contents.split("\n")

missing_parts = []
active_parts = []

def numbers_and_index(string)
  results = []
  string.scan(/\d+/) do |c|
    results << [c, Regexp.last_match.offset(0)[0]]
  end
  results
end

lines.each.with_index do |line, line_index|
  numbers_and_index(line).each do |number, index_in_line|
    touching_chars = []
    if line_index > 0
      previous_line = lines[line_index - 1]
      clamp_high = previous_line.length
      touching_chars << previous_line[(index_in_line - 1).clamp(0, clamp_high)..(index_in_line + number.chars.length).clamp(0, clamp_high)]
    end
    if index_in_line > 0
      touching_chars << line[(index_in_line - 1)]
    end
    if index_in_line + number.chars.length < line.length
      touching_chars << line[(index_in_line + number.chars.length)]
    end
    if line_index + 1 < lines.length
      next_line = lines[line_index + 1]
      clamp_high = next_line.length
      touching_chars << next_line[(index_in_line - 1).clamp(0, clamp_high)..(index_in_line + number.chars.length).clamp(0, clamp_high)]
    end

    # non "." characters are symbols
    if touching_chars.join("").gsub(".", "").empty?
      missing_parts << number
    else
      active_parts << number
    end
  end
end

# sum missing parts
puts missing_parts
puts active_parts.sum(&:to_i)

# puts all_numbers.sum