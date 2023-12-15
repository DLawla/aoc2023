require "ostruct"

file = File.open("11/input.txt")
contents = file.read

lines = contents.split("\n")

map = lines.reverse.map { |row| row.chars }

# expand empty rows
starting_length = map.length
map.length.times do |i|
  reverse_index = starting_length - 1 - i

  row = map[reverse_index]
  if row.uniq.length == 1 && row.first == "."
    map.insert(reverse_index, ["."] * row.length)
  end
end

# expand empty columns
starting_width = map.first.length
starting_width.times do |i|
  reverse_index = starting_width - 1 - i

  column = map.map {|row| row[reverse_index]}

  if column.uniq.length == 1 && column.first == "."
    map.each { |row| row.insert(reverse_index, ".") }
  end
end

puts "expanded map"
puts map.reverse.map(&:join)

galaxies = []

map.each.with_index do |row, y|
  row.each.with_index do |element, x|
    if element == "#"
      galaxies << OpenStruct.new(id: galaxies.length + 1, x:, y:)
    end
  end
end

puts galaxies

distances = []
galaxies.each.with_index do |galaxy, i|
  # get the min distance from each other galaxy by adding diff of x and y
  # trick: don't duplicate -- only compare this galaxy to the remaining

  if i == galaxies.length - 1
    break
  end

  distances << galaxies[i + 1..].map do |peer_galaxy|
    distance_x = (galaxy.x - peer_galaxy.x).abs
    distance_y = (galaxy.y - peer_galaxy.y).abs
    distance_x + distance_y
  end
end
puts distances.flatten.sum