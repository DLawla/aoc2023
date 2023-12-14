require "ostruct"

file = File.open("10/input.txt")
contents = file.read
s_is_a = "-" # from using my eyeballs

class Wander
  attr_accessor :current_location, :last_location, :map, :width, :height, :steps, :history

  def initialize(starting_location, map)
    @current_location = starting_location
    @last_location = nil
    @map = map
    @width = @map.values.max_by(&:x).x + 1
    @height = @map.values.max_by(&:y).y + 1
    @steps = 0
    @history = []
  end

  def go(direction)
    return false unless (next_location = location_to_the(direction))

    return false if next_location == last_location

    if can_go?(direction) && can_accept?(direction, next_location)
      @last_location = current_location
      @current_location = next_location
      @steps += 1
      @history << "#{next_location.x},#{next_location.y}"
      if @history.length != @history.uniq.length
        raise "backwards!"
      end
      true
    end
  end

  private

  def location_to_the(direction)
    return false if hit_boundary?(direction)

    case direction
    when :north
      map["#{current_location.x},#{current_location.y + 1}"]
    when :east
      map["#{current_location.x + 1},#{current_location.y}"]
    when :south
      map["#{current_location.x},#{current_location.y - 1}"]
    when :west
      map["#{current_location.x - 1},#{current_location.y}"]
    end
  end

  def hit_boundary?(direction)
    case direction
    when :north
      current_location.y == height - 1
    when :east
      current_location.x == width - 1
    when :south
      current_location.y == 0
    when :west
      current_location.x == 0
    end
  end

  def can_go?(direction)
    case direction
    when :north
      ["S", "|", "L", "J"].include?(current_location.symbol)
    when :east
      ["S", "-", "L", "F"].include?(current_location.symbol)
    when :south
      ["S", "|", "F", "7"].include?(current_location.symbol)
    when :west
      ["S", "-", "J", "7"].include?(current_location.symbol)
    end
  end

  def can_accept?(direction, next_location)
    case direction
    when :north
      ["|", "F", "7"].include?(next_location.symbol)
    when :east
      ["-", "J", "7"].include?(next_location.symbol)
    when :south
      ["|", "L", "J"].include?(next_location.symbol)
    when :west
      ["-", "L", "F"].include?(next_location.symbol)
    end
  end
end

# Build map
lines = contents.split("\n")
map = {}
lines.reverse.map.with_index do |row, y_index|
  row.chars.map.with_index do |symbol, x_index|
    map["#{x_index},#{y_index}"] = OpenStruct.new(x: x_index, y: y_index, symbol:)
  end
end.flatten

# Start
starting_location = map.values.find { |l| l.symbol == "S" }
wanderers = [Wander.new(starting_location, map), Wander.new(starting_location, map)]

# Iterate one step at a time
directions = [:north, :south, :east, :west]
while true
  wanderers.each.with_index do |wander, i|
    # for the first step, set the wanders in different directions
    if i == 0
      directions.find { |direction| wander.go(direction) }
    elsif i == 1
      directions.reverse.find { |direction| wander.go(direction) }
    end
  end

  if wanderers.any? {|w| w.current_location.symbol == "S" || w.current_location.symbol == "."}
    raise "Uh oh, bad location"
  end

  # print "."

  # puts wanderers.map(&:current_location)
  if wanderers[0].current_location == wanderers[1].current_location && wanderers[0].current_location.symbol != "S"
    break
  end
end

# now, study the history
points_in_loop = wanderers.map(&:history).flatten.uniq

# the trick is by line intersection -- go through line by line. There will always be 0 or an even number
# of loops points per line. Any points between intersections are in the loop.
width = lines.first.chars.length
height = lines.length

# determine what "S" is, and replace it in the map
starting = map.find {|k, v| v.symbol == "S"}
map[starting.first].symbol = s_is_a

enclosed_points = 0
height.times do |y_index|
  # going through row
  intersections_found = 0
  from_north_inflection_started = false
  from_south_inflection_started = false

  # an inflection point is when we have crossed the loop
  width.times do |x_index|
    symbol = map["#{x_index},#{y_index}"].symbol

    if points_in_loop.include?("#{x_index},#{y_index}")
      if symbol == "|"
        intersections_found += 1
      elsif symbol == "L"
        from_north_inflection_started = true
      elsif symbol == "F"
        from_south_inflection_started = true
      elsif symbol == "7"
        if from_north_inflection_started
          intersections_found += 1
        end
        from_north_inflection_started = false
        from_south_inflection_started = false
      elsif ["J"].include?(symbol)
        if from_south_inflection_started
          intersections_found += 1
        end
        from_north_inflection_started = false
        from_south_inflection_started = false
      end
    elsif intersections_found.odd?
      enclosed_points += 1
    end
  end

  if intersections_found.odd?
    raise "not possible, row #{y_index}"
  end
end

puts enclosed_points