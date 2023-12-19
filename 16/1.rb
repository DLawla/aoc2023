require "ostruct"

file = File.open("16/test.txt")
contents = file.read

# Build map
lines = contents.split("\n")
MAP = {}
lines.reverse.map.with_index do |row, y_index|
  row.chars.map.with_index do |symbol, x_index|
    MAP["#{x_index},#{y_index}"] = OpenStruct.new(x: x_index, y: y_index, symbol:, visited: false)
  end
end.flatten

class Wanderer
  attr_accessor :current_location, :direction

  def initialize(starting_location, direction)
    @current_location = starting_location
    @direction = direction
    @width = MAP.values.max_by(&:x).x + 1
    @height = MAP.values.max_by(&:y).y + 1
  end

  def go(direction)
    if MAP["#{@current_location.x},#{@current_location.y}"].visited
      return
    else
      MAP["#{@current_location.x},#{@current_location.y}"].visited = true
    end

    case @current_location.symbol
    when "."
      return unless (next_location = location_to_the(direction))
      [Wanderer.new(next_location, @direction)]
    when "-"
      if [:east, :west].include?(@direction)
        return unless (next_location = location_to_the(direction))
        [Wanderer.new(next_location, @direction)]
      else
        eastward = ((next_location = location_to_the(:east)) ? Wanderer.new(next_location, :east) : nil )
        westward = ((next_location = location_to_the(:west)) ? Wanderer.new(next_location, :west) : nil )
        [eastward, westward].compact
      end
    when "|"
      if [:north, :south].include?(@direction)
        return unless (next_location = location_to_the(direction))
        [Wanderer.new(next_location, @direction)]
      else
        northward = ((next_location = location_to_the(:north)) ? Wanderer.new(next_location, :north) : nil )
        southward = ((next_location = location_to_the(:south)) ? Wanderer.new(next_location, :south) : nil )
        [northward, southward].compact
      end
    when "\\"
      if @direction == :north
        return unless (next_location = location_to_the(:west))
        [Wanderer.new(next_location, :west)]
      elsif @direction == :south
        return unless (next_location = location_to_the(:east))
        [Wanderer.new(next_location, :east)]
      elsif @direction == :west
        return unless (next_location = location_to_the(:north))
        [Wanderer.new(next_location, :north)]
      elsif @direction == :east
        return unless (next_location = location_to_the(:south))
        [Wanderer.new(next_location, :south)]
      end
    when "/"
      if @direction == :north
        return unless (next_location = location_to_the(:east))
        [Wanderer.new(next_location, :east)]
      elsif @direction == :south
        return unless (next_location = location_to_the(:west))
        [Wanderer.new(next_location, :west)]
      elsif @direction == :west
        return unless (next_location = location_to_the(:south))
        [Wanderer.new(next_location, :south)]
      elsif @direction == :east
        return unless (next_location = location_to_the(:north))
        [Wanderer.new(next_location, :north)]
      end
    end
  end

  private

  def location_to_the(direction)
    return false if hit_boundary?(direction)

    case direction
    when :north
      MAP["#{current_location.x},#{current_location.y + 1}"]
    when :east
      MAP["#{current_location.x + 1},#{current_location.y}"]
    when :south
      MAP["#{current_location.x},#{current_location.y - 1}"]
    when :west
      MAP["#{current_location.x - 1},#{current_location.y}"]
    end
  end

  def hit_boundary?(direction)
    case direction
    when :north
      current_location.y == @height - 1
    when :east
      current_location.x == @width - 1
    when :south
      current_location.y == 0
    when :west
      current_location.x == 0
    end
  end
end

# start
# Start
starting_location = "0,#{MAP.values.max_by(&:y).y}"
wanderers = [Wanderer.new(MAP[starting_location], :east)]

while wanderers.any?
  wanderer, *wanderers = wanderers

  wanderers << wanderer.go(wanderer.direction)

  wanderers = wanderers.compact.flatten
end

MAP.select { |_l, v| v.visited }.count

width = MAP.values.max_by(&:x).x + 1
height = MAP.values.max_by(&:y).y + 1

results = (0..height - 1).map do |y|
  (0..(width - 1)).map.with_index do |x|
    location = MAP["#{x},#{y}"]
    if location.visited
      "#"
    else
      location.symbol
    end
  end.join
end
puts results.reverse.join("\n")