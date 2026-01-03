enum CardSuit { spade, heart, diamond, club }
enum CardRank { ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king }
enum CardStatus { hand, buffer, foundation, tableau }

class CardModel {
  final String id;
  final CardSuit suit;
  final CardRank rank;
  final bool isFaceUp;
  final CardStatus status;
  final int? stackIndex;
  final bool isLocked;

  CardModel({
    required this.id,
    required this.suit,
    required this.rank,
    this.isFaceUp = false,
    this.status = CardStatus.tableau,
    this.stackIndex,
    this.isLocked = false,
  });

  CardModel copyWith({
    bool? isFaceUp,
    CardStatus? status,
    int? stackIndex,
    bool? isLocked,
  }) {
    return CardModel(
      id: id,
      suit: suit,
      rank: rank,
      isFaceUp: isFaceUp ?? this.isFaceUp,
      status: status ?? this.status,
      stackIndex: stackIndex ?? this.stackIndex,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  bool get isRed => suit == CardSuit.heart || suit == CardSuit.diamond;
  
  int get rankValue => rank.index + 1;
  
  String get rankDisplay {
    switch (rank) {
      case CardRank.ace: return 'A';
      case CardRank.jack: return 'J';
      case CardRank.queen: return 'Q';
      case CardRank.king: return 'K';
      default: return rankValue.toString();
    }
  }
}
