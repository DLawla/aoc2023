require "ostruct"

file = File.open("10/input.txt")
contents = file.read

class Wander
  attr_accessor :current_location, :last_location, :map, :width, :height, :steps, :history

  def initialize(starting_location, map)
    @current_location = starting_location
    @last_location = nil
    @map = map
    @width = @map.values.max_by(&:x).x + 1
    @height = @map.values.max_by(&:y).y + 1
    @steps = 0
  end

  def go(direction)
    return false unless (next_location = location_to_the(direction))

    return false if next_location == last_location

    if can_go?(direction) && can_accept?(direction, next_location)
      @last_location = current_location
      @current_location = next_location
      @steps += 1
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

puts wanderers[0].steps
