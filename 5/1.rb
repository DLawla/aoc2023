file = File.open("5/input.txt")
contents = file.read

lines = contents.split("\n")

maps = []

seeds = lines.first.split("seeds: ")[1].scan(/\d+/).map(&:to_i)

lines[1..].map.with_index do |line, i|
  if line.include?("map:")
    map_key = line.split(" map").first
    maps << {source: map_key.split("-to-")[0], dest: map_key.split("-to-")[1], maps: []}
  else
    numbers = line.scan(/\d+/).map(&:to_i)
    if numbers.length == 3
      maps.last[:maps] << {dest: numbers[0], source: numbers[1], length: numbers[2]}
    end
  end
end

def converted_value(value, maps)
  converted = nil

  maps.each do |map|
    length = map[:length]
    source_start = map[:source]

    if value >= source_start && value < source_start + length
      converted = map[:dest] + (value - source_start)
    end
  end

  converted || value
end

# step through each seed
locations = seeds.map do |seed|
  location_found = false
  current_map_key = "seed"
  current_value = seed

  while !location_found
    current_map = maps.find do |map|
      map[:source] == current_map_key
    end

    # update current value with conversion
    current_value = converted_value(current_value, current_map[:maps])

    current_map_key = current_map[:dest]

    if current_map_key == "location"
      location_found = true
    end
    # location_found = true
  end

  {seed:, current_value:}
end

# puts locations
puts locations.map { |location| location[:current_value] }.min