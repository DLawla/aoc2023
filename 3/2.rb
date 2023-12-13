# open file names test.txt in current directory
file = File.open("3/input.txt")
contents = file.read

lines = contents.split("\n")

missing_parts = []
active_parts = []
@touched_gears = {}

def numbers_and_index(string)
  results = []
  string.scan(/\d+/) do |c|
    results << [c, Regexp.last_match.offset(0)[0]]
  end
  results
end

def gears_and_index(string)
  results = []
  string.scan(/\*/) do |c|
    results << [c, Regexp.last_match.offset(0)[0]]
  end
  results
end

def record_gear(key, number)
  if @touched_gears[key].nil?
    @touched_gears[key] = [number]
  else
    @touched_gears[key] << number
  end
end

lines.each.with_index do |line, line_index|
  numbers_and_index(line).each do |number, index_in_line|
    touching_chars = []
    if line_index > 0
      previous_line = lines[line_index - 1]
      clamp_high = previous_line.length
      starting_index = (index_in_line - 1).clamp(0, clamp_high)
      ending_index = (index_in_line + number.chars.length).clamp(0, clamp_high)
      chars = previous_line[starting_index..ending_index]
      gears_and_index(chars).each do |gear, gear_index|
        record_gear("#{line_index - 1},#{gear_index + starting_index}", number)
      end
      touching_chars << chars
    end
    if index_in_line > 0
      char = line[(index_in_line - 1)]
      if char == "*"
        record_gear("#{line_index},#{(index_in_line - 1)}", number)
      end
      touching_chars << char
    end
    if index_in_line + number.chars.length < line.length
      char = line[(index_in_line + number.chars.length)]
      if char == "*"
        record_gear("#{line_index},#{(index_in_line + number.chars.length)}", number)
      end
      touching_chars << char
    end
    if line_index + 1 < lines.length
      next_line = lines[line_index + 1]
      clamp_high = next_line.length
      starting_index = (index_in_line - 1).clamp(0, clamp_high)
      ending_index = (index_in_line + number.chars.length).clamp(0, clamp_high)
      chars = next_line[starting_index..ending_index]
      gears_and_index(chars).each do |gear, gear_index|
        record_gear("#{line_index + 1},#{gear_index + starting_index}", number)
      end
      touching_chars << chars
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
puts @touched_gears
puts @touched_gears.select { |k, v| v.length > 1 }.map { |k, v| v.map(&:to_i).reduce(&:*) }.sum
