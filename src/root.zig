const std = @import("std");

const Suit = enum {
    Clubs,
    Diamonds,
    Hearts,
    Spades,
};

const Card = struct {
    suit: Suit,
    value: u4,
};

const Deck = struct {
    cards: [52]Card,
    top: usize,

    pub fn init() Deck {
        var deck: Deck = .{ .cards = undefined, .top = 0 };
        var i: usize = 0;
        // inline for (std.meta.fields(Suit)) |suit| {
        for (0..3) |suit| {
            for (0..13) |value| {
                deck.cards[i] = Card{ .suit = @enumFromInt(suit), .value = @as(u4, @intCast(value)) + 1 };
                i += 1;
            }
        }
        return deck;
    }

    pub fn shuffle(deck: *Deck) void {
        // This should be moved out of the library; no need
        // to seed every time a deck is shuffled. How to pass rng from
        // from another function?
        var rng = std.rand.DefaultPrng.init(1);
        for (deck.cards, 0..) |_, item| {
            const i = deck.cards[item];
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
