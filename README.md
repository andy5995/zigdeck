[![Linux CI](https://github.com/andy5995/zigdeck/actions/workflows/linux.yml/badge.svg)](https://github.com/andy5995/zigdeck/actions/workflows/linux.yml)

# zigdeck

A library that creates and shuffles a deck of cards from which you can draw

The code builds but it's not yet complete.

Tested with the the development version of [zig](https://ziglang.org/) (may
not build with the last release).

## Example

```zig
    // initialize the deck. This must be done before shuffle.
    var deck = Deck.init();

    try std.testing.expectEqual(Suit.Clubs, deck.cards[0].suit);
    try std.testing.expectEqual(Face.Ace, deck.cards[0].face);
    try std.testing.expectEqual(Suit.Spades, deck.cards[48].suit);
    try std.testing.expectEqual(Face.King, deck.cards[51].face);

    // Seed the random number generator
    var rng = std.rand.DefaultPrng.init(@as(u64, @intCast(std.time.milliTimestamp())));

    Deck.shuffle(&deck, &rng.random());
    const card = Deck.getTopCard(&deck) orelse return;
    try std.testing.expectEqual(Suit.Clubs, card.suit);
    try std.testing.expectEqual(Face.Queen, card.face);

    std.debug.print("Top card: Suit = {}, Value = {}\n", .{ card.suit, card.face });
```
