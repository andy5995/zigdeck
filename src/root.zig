const std = @import("std");

const Card = struct {
    suit: Suit,
    value: u4,
};

const Suit = enum {
    Clubs,
    Diamonds,
    Hearts,
    Spades,
};

const Deck = struct {
    cards: [52]Card,
    top: usize,

    pub fn init() Deck {
        var deck: Deck = .{ .cards = undefined, .top = 0 };
        var i: usize = 0;
        for (Suit) |suit| {
            for (0..13) |value| {
                deck.cards[i] = Card{ .suit = suit, .value = value + 1 };
                i += 1;
            }
        }
        return deck;
    }

    pub fn shuffle(deck: *Deck) void {
        var rng = std.rand.DefaultPrng.seed(@intCast(u64, std.time.milliTimestamp()));
        for (deck.cards.enumerate()) |item| {
            const i = item.index;
            const j = rng.random().int(usize) % deck.cards.len;
            const temp = deck.cards[i];
            deck.cards[i] = deck.cards[j];
            deck.cards[j] = temp;
        }
    }


    pub fn getTopCard(deck: *Deck) ?Card {
        if (deck.top >= deck.cards.len) return null;
        const card = deck.cards[deck.top];
        deck.top += 1;
        return card;
    }
};

test "Deck operations" {
    var deck = Deck.init();
    Deck.shuffle(&deck);
    const card = Deck.getTopCard(&deck) orelse return;
    std.debug.print("Top card: Suit = {}, Value = {}\n", .{ card.suit, card.value });
}
