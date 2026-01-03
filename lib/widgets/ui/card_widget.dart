import 'package:flutter/material.dart';
import '../../models/card_model.dart';
import '../../core/app_theme.dart';

class CardWidget extends StatelessWidget {
  final CardModel card;
  final bool isLifted;
  final VoidCallback? onTap;

  const CardWidget({
    super.key,
    required this.card,
    this.isLifted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!card.isFaceUp) {
      return _buildCardBack();
    }
    return _buildCardFront();
  }

  Widget _buildCardBack() {
    return Container(
      width: 46,
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.deepSlot,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront() {
    final color = card.isRed ? AppTheme.deepRed : AppTheme.deepBlack;
    final icon = _getSuitIcon();

    return GestureDetector(
      onTap: onTap,
      child: Transform.scale(
        scale: isLifted ? 1.05 : 1.0,
        child: Container(
          width: 46,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, AppTheme.deepCard],
            ),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isLifted ? AppTheme.deepAccent.withOpacity(0.5) : Colors.white.withOpacity(0.5),
              width: isLifted ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isLifted ? 0.5 : 0.2),
                blurRadius: isLifted ? 15 : 4,
                offset: Offset(0, isLifted ? 8 : 2),
              ),
              if (isLifted)
                BoxShadow(
                  color: AppTheme.deepAccent.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
            ],
          ),
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.rankDisplay,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1,
                ),
              ),
              Expanded(
                child: Center(
                  child: Icon(icon, size: 14, color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSuitIcon() {
    switch (card.suit) {
      case CardSuit.spade:
        return Icons.filter_vintage;
      case CardSuit.heart:
        return Icons.favorite;
      case CardSuit.diamond:
        return Icons.change_history;
      case CardSuit.club:
        return Icons.spa;
    }
  }
}
