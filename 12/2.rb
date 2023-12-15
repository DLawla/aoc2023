require "ostruct"

file = File.open("12/test.txt")
contents = file.read

lines = contents.split("\n")

spring_conditions = lines

BROKEN = "#"
EMPTY = "."
MYSTERY = "?"
CLAIMED = "X"

def new_possibility(map:, broken_hints:, full_map:, full_map_index: 0)
  OpenStruct.new(map:, broken_hints:, full_map: full_map, full_map_index: full_map_index)
end

arrangements = spring_conditions.map do |spring_conditions|
  valid_possibilities = []

  full_map, broken_hints = spring_conditions.split(" ")
  full_map = full_map.chars
  full_broken_hints = broken_hints.split(",").map(&:to_i)

  # unfold
  full_map = ([full_map.join] * 5).join("?").chars
  full_broken_hints = full_broken_hints * 5

  # 1) start with the left broken_hints
  # 2) get the sum of the remaining broken_hints, broken_hints(x..).count + 1, the current broken_hints has to end before that
  # 3) scan this substring -- find all available places it can go
  # - scan each index, go to what the next index is after this broken_hints, if it's broken, invalid
  # - if valid, add it to a possibilities object
  # 4) re-run (3) with each possibilities object

  possibilities = [new_possibility(map: full_map, full_map: full_map, broken_hints: full_broken_hints)]

  # iterate until there is a possibility that has not been resolved
  while possibilities.any?
    possibility = possibilities.shift # remove first possibility

    broken_hints = possibility.broken_hints
    map = possibility.map

    # only analyze the first broken hint
    broken_hint_length = broken_hints.first

    # create a substring of the map to try to apply the start of this hint to
    characters_at_end_of_map_to_remove = if broken_hints.one?
                                           broken_hint_length - 1
                                         else
                                           broken_hints[1..].sum + broken_hints[1..].length + broken_hint_length - 1
                                         end

    substring_with_valid_starts = map[..map.length - characters_at_end_of_map_to_remove - 1]

    substring_with_valid_starts.each.with_index do |char, char_index|
      following_char = map[char_index + broken_hint_length] # char AFTER the end of this possibility
      if map[char_index..char_index + broken_hint_length - 1].any? { |c| c == EMPTY }
        next # this range straddles a known non-broken spring
      elsif map[char_index..char_index + broken_hint_length - 1].any? { |c| c == CLAIMED }
        next # this range straddles an already claimed (broken) spring
      elsif char_index != 0 && [BROKEN, CLAIMED].include?(substring_with_valid_starts[char_index - 1])
        next # this possibility won't work
      elsif [BROKEN, CLAIMED].include?(following_char)
        next # this possibility won't work
      else
        next_map = map[char_index..]
        next_map[0..broken_hint_length - 1] = [CLAIMED] * broken_hint_length
        next_hints = broken_hints[1..]

        # debug variables for tracking
        if char_index == 0 && possibility.full_map_index == 0
          next_full_map = next_map
        else
          next_full_map = possibility.full_map[0.. (possibility.full_map_index + char_index - 1).clamp(0, possibility.full_map.length)].map {|c| c == MYSTERY ? EMPTY : c} + next_map
        end
        next_full_map_index = possibility.full_map_index + char_index

        # determine if this possibility is valid, or move on
        updated_possibility = new_possibility(map: next_map, broken_hints: next_hints, full_map: next_full_map, full_map_index: next_full_map_index)

        # we are done and have a fully valid possibility!
        if updated_possibility.broken_hints.length == 0
          updated_possibility.full_map = updated_possibility.full_map.map {|c| c == MYSTERY ? EMPTY : c}

          if updated_possibility.full_map.select { |c| [BROKEN, CLAIMED].include?(c) }.length == full_broken_hints.sum
            valid_possibilities << updated_possibility
          end
        else
          possibilities << updated_possibility
        end
      end
    end
  end

  # puts spring_conditions
  # puts valid_possibilities.map(&:full_map).map(&:join)
  # puts valid_possibilities.count
  print "."
  valid_possibilities.count
end

puts "grand sum"
puts arrangements.sum
