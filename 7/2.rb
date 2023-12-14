require "ostruct"

file = File.open("7/input.txt")
contents = file.read

@types = ["high card", "pair", "two pair", "three of a kind", "full house", "four of a kind", "five of a kind"]
@card_ranks = %w[J 2 3 4 5 6 7 8 9 T Q K A]

def type_of(cards)
  joker_count = cards.chars.count("J")

  cards_without_jokers = cards.chars.reject { |c| c == "J" }

  joker_count.times do |i|
    random_joker_values = ["v", "w", "x", "y", "z"]
    cards_without_jokers << random_joker_values[i]
  end

  case cards_without_jokers.uniq.length
  when 1
    "five of a kind"
  when 2
    # either four of a kind or full house
    if cards.chars.sort[0..3].uniq.length == 1 || cards.chars.sort[1..4].uniq.length == 1
      if joker_count == 1
        "five of a kind"
      else
        "four of a kind"
      end
    else
      "full house"
    end
  when 3
    if cards.chars.sort[0..2].uniq.length == 1 || cards.chars.sort[1..3].uniq.length == 1 || cards.chars.sort[2..4].uniq.length == 1
      if joker_count == 2
        "five of a kind"
      elsif joker_count == 1
        "four of a kind"
      else
        "three of a kind"
      end
    else
      if joker_count == 1
        "full house"
      else
        "two pair"
      end
    end
  when 4
    if joker_count == 3
      "five of a kind"
    elsif joker_count == 2
      "four of a kind"
    elsif joker_count == 1
      "three of a kind"
    else
      "pair"
    end
  when 5
    if joker_count == 4 || joker_count == 5
      "five of a kind"
    elsif joker_count == 3
      "four of a kind"
    elsif joker_count == 2
      "three of a kind"
    elsif joker_count == 1
      "pair"
    else
      "high card"
    end
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
end

puts ordered_hands
puts @hands.count, winnings.last
puts winnings.sum