file = File.open("X/test.txt")
contents = file.read

lines = contents.split("\n")

# stuff = lines.map do |line|
#   _ = line.chars.select { |char| char =~ /\d/ }
#   ...
# end

# puts all_numbers.sum