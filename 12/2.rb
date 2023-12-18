# total refactor, and direct conversion of python code (2.py) copied from reddit
# # Copy from: https://www.reddit.com/r/adventofcode/comments/18ge41g/comment/kd221yp/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
@cache = {}

def recurse(lava, springs, result = 0)
  cache_key = [lava, springs]
  return @cache[cache_key] if @cache.key?(cache_key)

  if springs.empty?
    return !lava&.include?('#') ? 1 : 0
  end

  current, *springs = springs
  (lava.length - springs.sum - springs.length - current + 1).times do |i|
    if lava[0, i].include?('#')
      break
    end

    nxt = i + current
    if nxt <= lava.length && !lava[i, current].include?('.') && lava[nxt] != '#'
      result += recurse(lava[(nxt + 1)..], springs)
    end
  end

  # Cache the result before returning
  @cache[cache_key] = result
  result
end

file = File.open("12/input.txt")
data = file.read.split("\n").map { |line| line.split(" ") }

p1 = 0
p2 = 0

data.each do |lava, springs|
  springs = springs.split(",").map(&:to_i)
  p1 += recurse(lava, springs)
  p2 += recurse(([lava] * 5).join('?'), springs * 5)
end

puts "#{p1} #{p2}"
