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

# array = [[".", ".", "#", "#", ".", ".", "#", "#", "."], [".", ".", "#", ".", "#", "#", ".", "#", "."], [".", "#", ".", ".", ".", ".", ".", ".", "#"], [".", "#", ".", ".", ".", ".", ".", ".", "#"], [".", ".", "#", ".", "#", "#", ".", "#", "."], [".", ".", "#", "#", ".", ".", "#", "#", "."]]

def has_reflection?(array)
  split_array_in_half = array.each_slice(array.size / 2).to_a
  split_array_in_half[1] = split_array_in_half[1].reverse
  split_array_in_half[0] == split_array_in_half[1]
end

def find_reflection_line(array)
  i_s = 0
  i_e = 0
  index_of_reflection = nil
  # example: 1234
  # do the following scans:
  # 12
  # 1234
  # 34

  # example: 12345
  # do the following scans:
  # 12
  # 1234
  # 2345
  # 45
  (array.length - 1).times do |_i|
    # shift start forward (have reached end of array)
    if i_e == array.length - 1
      i_s += 1

      if array[i_s..i_e].length % 2 == 1
        i_s += 1
        if has_reflection?(array[i_s..i_e])
          index_of_reflection = array[i_s..i_e].length / 2 + i_s
          break
        end
      else
        if has_reflection?(array[i_s..i_e])
          index_of_reflection = array[i_s..i_e].length / 2 + i_s
          break
        end
      end
    # shift end forward
    else
      i_e += 1
      if i_e == array.length - 1
        i_s += 1
        if has_reflection?(array[i_s..i_e])
          index_of_reflection = array[i_s..i_e].length / 2 + i_s
          break
        end
      elsif array[i_s..i_e].length % 2 == 1
        i_e += 1
        if has_reflection?(array[i_s..i_e])
          index_of_reflection = array[i_s..i_e].length / 2 + i_s
          break
        end
      else
        if has_reflection?(array[i_s..i_e])
          index_of_reflection = array[i_s..i_e].length / 2 + i_s
          break
        end
      end
    end
  end

  index_of_reflection
end

results = maps.map do |map|
  rows = map.map(&:chars)
  columns = map.map(&:chars).transpose

  row_uniquness = rows.count - rows.uniq.count
  column_uniqueness = columns.count - columns.uniq.count

  # uniqueness should guide us to which one should have the reflection line, but not necessarily
  result = find_reflection_line(columns)
  if result
    puts "cols (vert)"
  else
    puts "rows (hor)"
  end
  result = find_reflection_line(rows) * 100 if !result

  # if column_uniqueness > row_uniquness
  #   result = find_reflection_line(columns)
  #   result = find_reflection_line(rows) * 100 if !result
  # else
  #   result = find_reflection_line(rows) * 100
  #   result = find_reflection_line(columns) if !result
  # end

  result
end

puts results
puts results.sum

# test should == (5 columns, 4 rows) 405