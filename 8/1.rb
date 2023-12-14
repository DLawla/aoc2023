require "ostruct"

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

location = "AAA"
steps = 0

while true do
  instructions.chars.each do |instruction|
    point = @points.find { |p| p.location == location }
    if instruction == "L"
      location = point.left
    elsif instruction == "R"
      location = point.right
    end

    steps += 1

    if location == "ZZZ"
      break
    end
  end

  if location == "ZZZ"
    break
  end
end

puts steps
