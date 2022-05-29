import 'package:flutter/material.dart';
import 'home_note.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      const Center(
        heightFactor: 10,
        child: Text(
          'My Note',
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 0, 103, 187),
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                  color: Color.fromARGB(255, 0, 103, 187),
                  offset: Offset(-5, 5),
                  blurRadius: 10)
            ],
          ),
        ),
      ),
      Center(
        child: ElevatedButton(
          child: const Text(
            'Get Started',
            style: TextStyle(fontSize: 24.0),
          ),
          onPressed: () {
            _navigateToNextScreen(context);
          },
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(200, 80)),
          ),
        ),
      ),
    ]));
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MyHomePage()));
  }
}
