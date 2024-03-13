const std = @import("std");

pub const Suit = enum {
    Clubs,
    Diamonds,
    Hearts,
    Spades,
};

pub const Face = enum(u8) {
    Ace = 1,
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven,
    Eight,
    Nine,
    Ten,
    Jack,
    Queen,
    King,
};

pub const Card = struct {
    suit: Suit,
    face: Face,
};

pub const Deck = struct {
    cards: [52]Card,
    top: usize,

    pub fn init() Deck {
        var deck: Deck = .{ .cards = undefined, .top = 0 };
        var i: usize = 0;
        inline for (std.meta.fields(Suit), 0..) |_, suit| {
            inline for (std.meta.fields(Face), 1..) |_, face| {
                deck.cards[i] = Card{ .suit = @enumFromInt(suit), .face = @enumFromInt(face) };
                i += 1;
            }
        }
        return deck;
    }

    pub fn shuffle(deck: *Deck, rng: *const std.rand.Random) void {
        for (deck.cards, 0..) |_, item| {
            const i = item;
            const j = rng.int(usize) % deck.cards.len;
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
    try std.testing.expectEqual(Suit.Clubs, deck.cards[0].suit);
    try std.testing.expectEqual(Face.Ace, deck.cards[0].face);
    try std.testing.expectEqual(Suit.Clubs, deck.cards[1].suit);
    try std.testing.expectEqual(Face.Two, deck.cards[1].face);
    try std.testing.expectEqual(Suit.Diamonds, deck.cards[13].suit);
    try std.testing.expectEqual(Face.Ace, deck.cards[13].face);
    try std.testing.expectEqual(Suit.Hearts, deck.cards[26].suit);
    try std.testing.expectEqual(Face.Ace, deck.cards[26].face);
    try std.testing.expectEqual(Suit.Spades, deck.cards[48].suit);
    try std.testing.expectEqual(Face.King, deck.cards[51].face);

    // var rng = std.rand.DefaultPrng.init(@as(u64, @intCast(std.time.milliTimestamp())));
    var rng = std.rand.DefaultPrng.init(1);
    Deck.shuffle(&deck, &rng.random());
    const card = Deck.getTopCard(&deck) orelse return;
    try std.testing.expectEqual(Suit.Clubs, card.suit);
    try std.testing.expectEqual(Face.Queen, card.face);
    std.debug.print("Top card: Suit = {}, Value = {}\n", .{ card.suit, card.face });
}
