require "ostruct"

file = File.open("5/input.txt")
contents = file.read

lines = contents.split("\n")

@ranges = []
@maps = []

def new_range(key:, start:, length:)
  OpenStruct.new(key: key, start: start, length: length)
end

def new_map(source:, dest:)
  OpenStruct.new(dest: dest, source: source, map_ranges: [])
end

# build current "ranges"
seeds = lines.first.split("seeds: ")[1].scan(/\d+/).map(&:to_i)
seeds.each_slice(2).to_a.each do |start, length|
  @ranges << new_range(key:"seed", start:, length:)
end

# build maps "ranges"
lines[1..].map.with_index do |line, i|
  if line.include?("map:")
    map_key = line.split(" map").first
    @maps << new_map(source: map_key.split("-to-")[0], dest: map_key.split("-to-")[1])
  else
    numbers = line.scan(/\d+/).map(&:to_i)
    if numbers.length == 3
      @maps.last.map_ranges << OpenStruct.new(dest: numbers[0], source: numbers[1], length: numbers[2])
    end
  end
end

def converted_value(value, maps)
  converted = nil

  maps.each do |map|
    length = map.length
    source_start = map.source

    if value >= source_start && value < source_start + length
      converted = map.dest + (value - source_start)
    end
  end

  converted || value
end

def increment_ranges
  new_ranges = []
  @ranges.length.times do |i|
    range = @ranges[i]
    map = @maps.find { |map| map.source == range.key }

    preconverted_ranges = []

    map.map_ranges.each do |map_range|
      if map_range.source <= range.start && (map_range.source + map_range.length) >= (range.start + range.length)
        # the range fully within the map
        _range = new_range(key: map.dest, start: range.start, length: range.length)
        preconverted_ranges << _range.dup
        _range.start = converted_value(_range.start, [map_range])
        new_ranges << _range
      elsif map_range.source.between?(range.start, range.start + range.length)
        # the start of this map overlaps the range. build a new range with a length of the total overlap
        start = map_range.source
        length = [(range.start + range.length) - map_range.source, (map_range.source + map_range.length) - start].min
        _range = new_range(key: map.dest, start: start, length: length)
        preconverted_ranges << _range.dup
        if _range.start < 0
          raise "Uh oh"
        end
        _range.start = converted_value(_range.start, [map_range])
        new_ranges << _range
      elsif (map_range.source + map_range.length).between?(range.start, range.start + range.length)
        # the end of this map overlaps the range. build a new range with a length of the total overlap
        # length is the min between difference of map length AND range.start + range.length - (map_range.source + map_range.length)
        start = range.start
        _range = new_range(key: map.dest, start: start, length: map_range.source + map_range.length - start)
        preconverted_ranges << _range.dup
        _range.start = converted_value(_range.start, [map_range])
        new_ranges << _range
      end
    end

    # Overly complicated
    # now, find any parts of the overall range that don't overlap with conversion maps
    if preconverted_ranges.none?
      new_ranges << new_range(key: map.dest, start: range.start, length: range.length)
    elsif preconverted_ranges.length == 1
      start = preconverted_ranges.first.start
      length = preconverted_ranges.last.length

      # if the range exactly matches the whole range, do nothing
      if start == range.start && length == range.length
        #
      elsif start > range.start
        # the only range starts after the start of the current
        new_ranges << new_range(key: map.dest, start: range.start, length: (start - range.start))
      elsif (start + length < (range.start + range.length))
        # the only range starts at the beginning of the range, and ends before
        new_ranges << new_range(key: map.dest, start: start + length, length: range.start + range.length - (start + length))
      end
    else
      preconverted_ranges.sort_by {|range| range.start}.map {|range| [range.start, range.length] }.each.with_index do |temp_range, i|
        start = temp_range.first
        length = temp_range.last

        if i == 0
          if range.start < start
            new_ranges << new_range(key: map.dest, start: range.start, length: (start - range.start))
          end
        else
          last = preconverted_ranges[i - 1]

          if  i == preconverted_ranges.length - 1
            # last range
            if start + length < range.start + range.length
              new_ranges << new_range(key: map.dest, start: start + length, length: (range.start + range.length - (start + length)))
            end
          else
            if last.start + last.length < start
              new_ranges << new_range(key: map.dest, start: last.start + last.length, length: (start - (last.start + last.length)))
            end
          end
        end
      end
    end
  end
  @ranges = new_ranges
end

while true
  increment_ranges

  # puts @ranges.sort_by {|range| range.start}

  if @ranges.all? { |range| range.key == "location" }
    break
  end
end

puts "Lowest location range:"
puts @ranges.min_by { |range| range.start }