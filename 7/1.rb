require "ostruct"

file = File.open("7/input.txt")
contents = file.read

@types = ["high card", "pair", "two pair", "three of a kind", "full house", "four of a kind", "five of a kind"]
@card_ranks = %w[2 3 4 5 6 7 8 9 T J Q K A]

def type_of(cards)
  case cards.chars.uniq.length
  when 1
    "five of a kind"
  when 2
    # either four of a kind or full house
    if cards.chars.sort[0..3].uniq.length == 1 || cards.chars.sort[1..4].uniq.length == 1
      "four of a kind"
    else
      "full house"
    end
  when 3
    if cards.chars.sort[0..2].uniq.length == 1 || cards.chars.sort[1..3].uniq.length == 1 || cards.chars.sort[2..4].uniq.length == 1
      "three of a kind"
    else
      "two pair"
    end
  when 4
    "pair"
  when 5
    "high card"
  end
end

def value_of(cards, type)
  alphabet = ('a'..'z').to_a
  type_index = @types.find_index(type)
  ranks_indices = cards.chars.map {|card| @card_ranks.find_index(card) }
  [type_index, ranks_indices].flatten.map {|i| alphabet[i] }.join("")
end

def build_hand(cards:, bid:)
  type = type_of(cards)
  value = value_of(cards, type)
  OpenStruct.new(cards: cards, type: type, value: value, bid: bid)
end

@hands = []
contents.split("\n").each do |line|
  cards = line.split(" ").first
  bid = line.split(" ").last.to_i

  @hands << build_hand(cards: cards, bid: bid)
end

ordered_hands = @hands.sort_by(&:value)

winnings = ordered_hands.map.with_index do |hand, i|
  hand.bid * (i + 1)
end.reduce(&:+)

puts winnings