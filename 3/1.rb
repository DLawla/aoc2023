file = File.open("2/input.txt")
contents = file.read

lines = contents.split("\n")

# all_numbers = lines.map do |line|
#   numbers = line.chars.select { |char| char =~ /\d/ }
#
# end

# puts all_numbers.sum