file = File.open("13/input.txt")
contents = file.read

def create_2d_array(input_array)
  result_array = []
  current_subarray = []

  input_array.each do |element|
    if element.empty?
      result_array << current_subarray unless current_subarray.empty?
      current_subarray = []
    else
      current_subarray << element
    end
  end

  result_array << current_subarray unless current_subarray.empty?
  result_array
end

lines = contents.split("\n")
maps = create_2d_array(lines)

def has_reflection?(array)
  split_array_in_half = array.each_slice(array.size / 2).to_a
  split_array_in_half[1] = split_array_in_half[1].reverse
  split_array_in_half[0] == split_array_in_half[1]
end

def calc_index_of_reflection(array, i_s, exclude)
  index_of_reflection = array.length / 2 + i_s
  return false if exclude && exclude == index_of_reflection
  index_of_reflection
end

def find_reflection_line(array, exclude: nil)
  i_s = 0
  i_e = 0
  index_of_reflection = nil

  (array.length - 1).times do |_i|
    # shift start forward (have reached end of array)
    if i_e == array.length - 1
      i_s += 1
      if array[i_s..i_e].length % 2 == 1
        i_s += 1
        #
      else
        #
      end

      # shift end forward
    else
      i_e += 1
      if i_e == array.length - 1
        i_s += 1
      elsif array[i_s..i_e].length % 2 == 1
        i_e += 1
      else
        #
      end
    end

    break if has_reflection?(array[i_s..i_e]) && (index_of_reflection = calc_index_of_reflection(array[i_s..i_e], i_s, exclude))
  end

  index_of_reflection
end

results = maps.map.with_index do |map, i|
  rows = map.map(&:chars)
  columns = map.map(&:chars).transpose

  if (result = find_reflection_line(columns))
    direction = "vertical"
  else
    result = find_reflection_line(rows)
    direction = "horizontal"
  end

  new_result = nil
  rows.each.with_index do |row, y|
    row.each.with_index do |char, x|
      modified_rows = rows.map.each(&:dup)
      if char == "#"
        modified_rows[y][x] = "."
      else
        modified_rows[y][x] = "#"
      end

      if (new_result = find_reflection_line(modified_rows, exclude: direction == "horizontal" && result))
        new_result = new_result * 100
      elsif (new_result = find_reflection_line(modified_rows.transpose, exclude: direction == "vertical" && result))
        #
      end

      break if new_result
    end
    break if new_result
  end
  new_result
end

puts results.sum

# test should == (5 columns, 4 rows) 405