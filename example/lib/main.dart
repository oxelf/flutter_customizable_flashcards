import 'package:flutter/material.dart';
import 'package:customizable_flashcard/customizable_flashcard.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FlashCard(
              ontap: () {},
              frontWidget: const Text("Front"),
              backWidget: const Text("Back"),
              frontColor: Colors.red,
              backGradient: LinearGradient(
                colors: [Colors.red, Colors.blue],
              )),
        ),
      ),
    );
  }
}
