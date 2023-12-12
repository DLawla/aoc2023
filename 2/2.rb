file = File.open("2/input.txt")
contents = file.read

lines = contents.split("\n")

MAX_DRAW = {
  red: 12,
  green: 13,
  blue: 14,
}

def draws(line)
  line.split(";").map(&:to_i)
end

games = lines.map do |line|
  game_number = line.split(":").first.delete("Game ").to_i

  summary = {
    game: game_number,
    red: 0,
    green: 0,
    blue: 0,
  }

  results = line.split(": ").last
  draws = results.split(";")
  draws.each do |draw|
    cubes = draw.split(", ").map(&:strip)
    cubes.each do |cube|
      number = cube.match(/\d*/).to_s.to_i
      color = cube.match(/[a-z]+/).to_s

      if summary[color.to_sym] < number
        summary[color.to_sym] = number
      end
    end
  end

  summary
end

def power_of_game(game)
  game[:red] * game[:green] * game[:blue]
end

# get ids of valid games
puts games.map {|game| power_of_game(game)}.sum
