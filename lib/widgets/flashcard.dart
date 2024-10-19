import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

class Flashcard extends StatefulWidget {
  final String term;
  final String definition;
  final String direction;
  final FlipCardController? controller;
  const Flashcard({super.key, required this.term, required this.definition, required this.direction, this.controller});

  @override
  FlashcardState createState() => FlashcardState();
}

class FlashcardState extends State<Flashcard> {
  @override
  Widget build(BuildContext context) {
    return FlipCard(
        controller: widget.controller,
        fill: Fill.fillBack,
        direction: widget.direction == "vertical" ? FlipDirection.VERTICAL : FlipDirection.HORIZONTAL,
        speed: 300,
        front: Card(
            child: Padding(
          padding: const EdgeInsets.all(18),
          child: Center(
            child: Text(
              widget.term,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24.0),
            ),
          ),
        )),
        back: Card(
            child: Padding(
          padding: const EdgeInsets.all(18),
          child: Center(
            child: Text(
              widget.definition,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24.0),
            ),
          ),
        )));
  }
} 