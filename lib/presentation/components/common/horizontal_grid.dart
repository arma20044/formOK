import 'package:flutter/material.dart';
import 'info_card.dart';

class InfoCardHorizontalList extends StatelessWidget {
  final List<InfoCard> cards;

  const InfoCardHorizontalList({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220, // 🔹 suficiente para mostrar la tarjeta completa
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) => cards[index],
      ),
    );
  }
}
