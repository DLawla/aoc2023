require "ostruct"
require "active_support/all"

file = File.open("8/input.txt")
contents = file.read

lines = contents.split("\n")

def new_point(location:, left:, right:)
  OpenStruct.new(location: location, left: left, right: right)
end

instructions = lines[0]
points_lines = lines[2..]

@points = []
points_lines.each do |point_line|
  coordinates = point_line.split(" = ").last
  coordinates.gsub!("(", "")
  coordinates.gsub!(")", "")
  left, right = coordinates.split(", ")
  @points << new_point(location: point_line.split(" = ").first, left:, right:)
end

steps = 0

starting_points = @points.select { |p| p.location.end_with?("A") }

locations = starting_points.map do |point|
  OpenStruct.new(location: point.location, history: [], repeats_every: nil)
end

instructions_enum = instructions.chars.cycle

while true do
  instruction = instructions_enum.next

  locations.each do |location|
    next if location.repeats_every.present?

    point = @points.find { |p| p.location == location.location }

    if instruction == "L"
      location.location = point.left
    elsif instruction == "R"
      location.location = point.right
    end

    if location.location.end_with?("Z")
      location.repeats_every = steps + 1
    end
  end

  steps += 1

  if steps % 1000 == 0
    puts "count #{steps}: #{locations.select { |location| location.repeats_every.present? }.count}/#{locations.count}"
  end

  if locations.all? { |location| location.repeats_every.present? }
    break
  end
end

puts steps
puts locations
puts locations.map(&:repeats_every)
puts locations.map(&:repeats_every).reduce(:lcm)
