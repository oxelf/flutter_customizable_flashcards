import 'package:customizable_flashcard/flashcard_side_enum.dart';
import 'package:flutter/material.dart';
import 'package:customizable_flashcard/customizable_flashcard.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isTapped = false;
  FlashCardSide side = FlashCardSide.front;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlashCard(
                  ontap: () {
                    setState(() {
                      isTapped = true;
                    });
                  },
                  onFlip: (newSide) {
                    setState(() {
                      side = newSide;
                    });
                  },
                  frontWidget: const Center(child: Text("Front")),
                  backWidget: const Center(child: Text("Back")),
                  frontGradient: const LinearGradient(
                    colors: [Colors.red, Colors.blue],
                  ),
                  backGradient: const LinearGradient(
                    colors: [Colors.red, Colors.blue],
                  )),
              Text("isPressed: $isTapped"),
              Text("current side: $side"),
            ],
          ),
        ),
      ),
    );
  }
}
