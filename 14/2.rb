file = File.open("14/input.txt")
contents = file.read

map = contents.split("\n")

ROCK = "O"
POST = "#"
EMPTY = "."

rows = map.map(&:chars)

def evaluate(rows)
  transposed = rows.map(&:dup).transpose
  transposed.each do |row|
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
  transposed.transpose
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

def tilt_in_direction(rows, direction)
  case direction
  when :north
    result = evaluate(rows)
    rows = result
  when :east
    result = evaluate(rotate_array_90(3, rows))
    rows = rotate_array_90(1, result)
  when :south
    result = evaluate(rotate_array_90(2, rows))
    rows = rotate_array_90(2, result)
  when :west
    result = evaluate(rotate_array_90(1, rows))
    rows = rotate_array_90(3, result)
  end
  rows
end

def cycle(rows)
  [:north, :west, :south, :east].each do |direction|
    rows = tilt_in_direction(rows, direction)
  end
  rows
end

# Do cycles
@cache = {}
repeats_every = nil
cycles_performed = nil
# this will exit early
1000000000.times do |i|
  rows = cycle(rows)

  if (stored = @cache[rows.join])
    repeats_every = i - stored
    cycles_performed = i + 1
    break
  else
    @cache[rows.join] = i
  end
  print '.'
end

puts "repeats every #{repeats_every}"

((1000000000 - cycles_performed) % repeats_every).times do
  rows = cycle(rows)
end

values = rows.map.with_index do |row, i|
  value = rows.first.length - i
  row.select { |char| char == ROCK }.count * value
end

puts values.sum