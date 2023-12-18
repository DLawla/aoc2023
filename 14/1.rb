file = File.open("14/input.txt")
contents = file.read

map = contents.split("\n")

ROCK = "O"
POST = "#"
EMPTY = "."

rows = map.map(&:chars)

def evaluate(rows)
  rows.each do |row|
    cursor = 0

    while true
      if cursor >= row.length
        break
      end
      if !row[cursor..].include?(ROCK)
        break
      end

      if [POST, ROCK].include? row[cursor]
        cursor += 1
      else
        next_non_empty_index = nil

        row[cursor..].each.with_index do |loc, i|
          if [POST, ROCK].include?(loc)
            next_non_empty_index = cursor + i
            break
          end
        end
        break unless next_non_empty_index

        if row[next_non_empty_index] == POST
          cursor = next_non_empty_index + 1
        elsif row[next_non_empty_index] == ROCK
          row[cursor] = ROCK
          row[next_non_empty_index] = EMPTY
          cursor += 1
        end
      end
    end
  end
  rows
end

def friendly_print(rows)
  puts rows.map(&:join).join("\n")
end

def rotate_array_90(times, array)
  times.times do
    array = array.transpose
    array = array.map(&:reverse)
  end
  array
end

directions = [:north, :east, :south, :west]
direction = :north
case direction
when :north
  result = evaluate(rows.transpose)
  rows = result.transpose
when :east
  # result = evaluate(rotate_array_90(3, rows))
  # rows = rotate_array_90(1, result)
  result = evaluate(rows)
  rows = result
when :south
  # rotate array 180 degrees
  # rows = rows.map(&:reverse).revese
  # result = evaluate(rows)
  # rows = result.map(&:reverse).revese
when :west
  # friendly_print(rows.map(&:reverse))
  # result = evaluate(rows.map(&:reverse))
  # friendly_print(result)
  # rows = result.map(&:reverse)
end

# transpose.map(&:reverse) rotate 90 degrees clockwise

values = rows.map.with_index do |row, i|
  value = rows.first.length - i
  row.select { |char| char == ROCK }.count * value
end

puts rows.map(&:join).join("\n")

# puts values
puts values.sum