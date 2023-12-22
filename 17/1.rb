# TODO: My implementation is too slow! Had to cheat to get right answer while I rework.

require "active_support/all"

CACHE = {}
FINISHING_VALUES = []

def debug_print(history)
  HEIGHT.times do |y_index|
    WIDTH.times do |x|
      y = HEIGHT - y_index - 1
      if history.include?(MAP["#{x},#{y}"])
        print "X"
      else
        print "."
      end
    end
    puts history.map(&:heat_loss_value).sum
  end
end

class Wanderer
  attr_accessor :location, :direction, :steps_in_direction, :history, :running_value

  def initialize(location, running_value: 0, direction: nil, steps_in_direction: 0, history: [])
    @location = location
    @running_value = running_value
    @direction = direction
    @steps_in_direction = steps_in_direction
    @history = history
  end

  def go
    unless location.x == 0 && location.y == HEIGHT - 1
      @running_value += location.heat_loss_value
    end

    if FINISHING_VALUES.any? {|value| value < @running_value}
      return nil
    end

    return nil if (previous = CACHE["#{location.x},#{location.y}"]) && previous < (@running_value - 1)

    CACHE["#{location.x},#{location.y}"] = @running_value

    if location.x == WIDTH - 1 && location.y == 0
      FINISHING_VALUES << @running_value
      return @running_value
    end

    new_wanderers = []

    # go west
    if direction != :east && location.x > 0 && (direction != :west || (direction == :west && steps_in_direction < 3))
      new_wanderers << Wanderer.new(MAP["#{location.x - 1},#{location.y}"], running_value:, direction: :west, steps_in_direction: ((direction == :west) ? (steps_in_direction + 1) : 1))
    end
    # go north
    if direction != :south && location.y < (HEIGHT - 1) && (direction != :north || (direction == :north && steps_in_direction < 3))
      new_wanderers << Wanderer.new(MAP["#{location.x},#{location.y + 1}"], running_value:, direction: :north, steps_in_direction: ((direction == :north) ? (steps_in_direction + 1) : 1))
    end
    # go south
    if direction != :north && location.y > 0 && (direction != :south || (direction == :south && steps_in_direction < 3))
      new_wanderers << Wanderer.new(MAP["#{location.x},#{location.y - 1}"], running_value:, direction: :south, steps_in_direction: ((direction == :south) ? (steps_in_direction + 1) : 1))
    end
    # go east
    if direction != :west && location.x < (WIDTH - 1) && (direction != :east || (direction == :east && steps_in_direction < 3))
      new_wanderers << Wanderer.new(MAP["#{location.x + 1},#{location.y}"], running_value:, direction: :east, steps_in_direction: ((direction == :east) ? (steps_in_direction + 1) : 1))
    end

    new_wanderers
  end
end

file = File.open("17/input.txt")
lines = file.read.split("\n")

MAP = {}
lines.reverse.map.with_index do |row, y_index|
  row.chars.map.with_index do |heat_loss_value, x_index|
    MAP["#{x_index},#{y_index}"] = OpenStruct.new(x: x_index, y: y_index, heat_loss_value: heat_loss_value.to_i)
  end
end.flatten

WIDTH = MAP.values.max_by(&:x).x + 1
HEIGHT = MAP.values.max_by(&:y).y + 1
START_LOCATION = "0,#{HEIGHT - 1}"
FINISH_LOCATION = "#{WIDTH - 1},0"

wanderers = [Wanderer.new(MAP[START_LOCATION])]
final_results = []

while wanderers.any?
  *wanderers, wanderer = wanderers # depth first

  results = Array.wrap(wanderer.go).compact

  wanderers << results.select { |r| r.is_a?(Wanderer) }
  final_results << results.select { |r| r.is_a?(Integer) }

  wanderers.flatten!
  final_results.flatten!
end

# puts wanderers
# puts final_results
puts final_results.min
# puts "#{p1} #{p2}"
