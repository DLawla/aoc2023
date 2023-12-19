file = File.open("15/input.txt")
contents = file.read

words = contents.split(",")

def hash_chars(chars)
  current_value = 0
  chars.each do |char|
    ascii_code = char.ord
    current_value += ascii_code
    current_value = current_value * 17
    current_value = current_value % 256
  end
  current_value
end

boxes = {}
256.times { |i| boxes[i] = [] }

words.each do |word|
  if word.include?("-")
    # remove anything in this box
    label = word.split("-").first
    box_number = hash_chars(label.chars)

    if match = boxes[box_number].find {|l_label, fl| label == l_label }
      boxes[box_number].delete(match)
    end
  else
    # add if not present, replace if present
    label = word.split("=").first
    focal_length = word.split("=").last.to_i
    box_number = hash_chars(label.chars)

    if match = boxes[box_number].find {|l_label, fl| label == l_label }
      index = boxes[box_number].index(match)
      boxes[box_number][index] = [label, focal_length]
    else
      boxes[box_number] << [label, focal_length]
    end
  end
end

focusing_powers = boxes.map do |box_no, v|
  box_value = box_no + 1
  lens_values = v.map.with_index {|lens, i| lens.last * (i + 1) }.sum

  box_value * lens_values
end

puts focusing_powers.sum
