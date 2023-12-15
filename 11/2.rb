require "ostruct"

file = File.open("11/input.txt")
contents = file.read

lines = contents.split("\n")

map = lines.reverse.map { |row| row.chars }

# get expandable row indices
expandable_rows = []
starting_length = map.length
map.length.times do |i|
  reverse_index = starting_length - 1 - i

  row = map[reverse_index]
  if row.uniq.length == 1 && row.first == "."
    expandable_rows << reverse_index
  end
end

# expand empty columns
expandable_columns = []
starting_width = map.first.length
starting_width.times do |i|
  reverse_index = starting_width - 1 - i

  column = map.map {|row| row[reverse_index]}

  if column.uniq.length == 1 && column.first == "."
    expandable_columns << reverse_index
  end
end

expandable_rows.reverse!
expandable_columns.reverse!

galaxies = []

map.each.with_index do |row, y|
  row.each.with_index do |element, x|
    if element == "#"
      galaxies << OpenStruct.new(id: galaxies.length + 1, x:, y:)
    end
  end
end

distances = []
galaxies.each.with_index do |galaxy, i|
  # get the min distance from each other galaxy by adding diff of x and y
  # trick: don't duplicate -- only compare this galaxy to the remaining

  if i == galaxies.length - 1
    break
  end

  distances << galaxies[i + 1..].map do |peer_galaxy|
    # determine the number of expandable COLUMNS between each
    distance_x = (galaxy.x - peer_galaxy.x).abs
    start_of_range = [galaxy.x, peer_galaxy.x].min
    end_of_range = [galaxy.x, peer_galaxy.x].max
    expandable_columns_between = expandable_columns.select { |x_index| (start_of_range.. end_of_range).include?(x_index) }.count
    distance_x = distance_x - expandable_columns_between + (expandable_columns_between * 1_000_000)

    # determine the number of expandable ROWS between each
    distance_y = (galaxy.y - peer_galaxy.y).abs
    start_of_range = [galaxy.y, peer_galaxy.y].min
    end_of_range = [galaxy.y, peer_galaxy.y].max
    expandable_rows_between = expandable_rows.select { |y_index| (start_of_range.. end_of_range).include?(y_index) }.count
    distance_y = distance_y - expandable_rows_between + (expandable_rows_between * 1_000_000)

    distance_x + distance_y
  end
end
puts distances.flatten.sum