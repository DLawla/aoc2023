file = File.open("18/input.txt")
contents = file.read
lines = contents.split("\n")
dig_plans = lines.map { |line| line.split(" ")[0..1] }

MOVEMENTS = {R: [1, 0], L: [-1, 0], U: [0, 1], D: [0, -1]}
digs = []
location = [0, 0]

dig_plans.each do |dig_plan|
  direction = dig_plan[0]
  distance = dig_plan[1].to_i

  movement = MOVEMENTS[direction.to_sym]

  distance.times do |i|
    location[0] += movement[0]
    location[1] += movement[1]
    digs << location.dup
  end
end

max_x = digs.max_by { |dig| dig[0] }[0]
min_x = digs.min_by { |dig| dig[0] }[0]
max_y = digs.max_by { |dig| dig[1] }[1]
min_y = digs.min_by { |dig| dig[1] }[1]

width = max_x - min_x + 1
height = max_y - min_y + 1

# shift coordinates so that the top left corner is at 0, 0
digs = digs.map { |dig| [dig[0] - min_x, dig[1] - max_y] }

count = 0
height.times do |y|
  vertical_boundary_found = false
  from_north_boundary_started = false
  from_south_boundary_started = false

  width.times do |x|
    on_boundary = digs.include?([x, -y])
    if on_boundary
      boundary_above = digs.include?([x, -(y + 1)])
      boundary_below = digs.include?([x, -(y - 1)])

      if boundary_above && boundary_below
        vertical_boundary_found = !vertical_boundary_found
      elsif boundary_above
        if from_south_boundary_started
          vertical_boundary_found = !vertical_boundary_found
          from_south_boundary_started = false
        elsif from_north_boundary_started
          from_north_boundary_started = false
        else
          from_north_boundary_started = true
        end
      elsif boundary_below
        if from_north_boundary_started
          vertical_boundary_found = !vertical_boundary_found
          from_north_boundary_started = false
        elsif from_south_boundary_started
          from_south_boundary_started = false
        else
          from_south_boundary_started = true
        end
      end
    end

    if on_boundary
      count += 1
    elsif vertical_boundary_found
      count += 1
    else
      #
    end
  end
end
puts count

# puts map
# puts ""


# map = []
# height.times do |y|
#   map << width.times.map do |x|
#     digs.include?([x + min_x, -(y - max_y)]) ? "#" : "."
#   end.join
# end
#
# puts map
# puts ""

# def flood_fill(map, x, y)
#   return if x < 0 || y < 0 || x >= map[0].length || y >= map.length || map[y][x] != "."
#
#   map[y][x] = "#"
#
#   flood_fill(map, x + 1, y)
#   flood_fill(map, x - 1, y)
#   flood_fill(map, x, y + 1)
#   flood_fill(map, x, y - 1)
# end
#
# height.times do |y|
#   if map[y].count("#") == 2
#     index_if_first_dig = map[y].index("#") + 1
#     puts "INDEX FOUND: #{index_if_first_dig}, #{y}"
#     flood_fill(map, index_if_first_dig, -y)
#     break
#   end
# end
# puts map

# puts map.flat_map(&:chars).count("#")
