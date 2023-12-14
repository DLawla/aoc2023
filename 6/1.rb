file = File.open("6/test.txt")
contents = file.read

lines = contents.split("\n")

races_times = lines[0].scan(/\d+/).map(&:to_i)
races_distances = lines[1].scan(/\d+/).map(&:to_i)

races = races_times.zip(races_distances)

def ways_to_win(time, record_distance)
  winning_count = 0
  time.times do |i|
    time_held = i + 1

    velocity = time_held

    time_for_travel = time - time_held

    distance_traveled = time_for_travel * velocity

    if distance_traveled > record_distance
      winning_count += 1
    end
  end
  winning_count
end

results = races.map do |time, distance|
  ways_to_win(time, distance)
end

print results



# stuff = lines.map do |line|
#   _ = line.chars.select { |char| char =~ /\d/ }
#   ...
# end

# puts all_numbers.sum