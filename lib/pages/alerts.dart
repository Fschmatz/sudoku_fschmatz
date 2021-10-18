import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlertGameOver extends StatelessWidget {
  static bool newGame = false;
  static bool restartGame = false;

  const AlertGameOver({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text(
        'Congratulations',
      ),
      content: const Text(
        'You successfully solved the Sudoku',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            newGame = true;
          },
          child: const Text('New Game'),
        ),
      ],
    );
  }
}

class AlertDifficultyState extends StatefulWidget {
  String currentDifficultyLevel;

  AlertDifficultyState(String currentDifficultyLevel, {Key key})
      : super(key: key) {
    currentDifficultyLevel = currentDifficultyLevel;
  }

  @override
  AlertDifficulty createState() => AlertDifficulty(currentDifficultyLevel);

  static get difficulty {
    return AlertDifficulty.difficulty;
  }

  static set difficulty(String level) {
    AlertDifficulty.difficulty = level;
  }
}

class AlertDifficulty extends State<AlertDifficultyState> {
  static String difficulty;
  static final List<String> difficulties = [
    'beginner',
    'easy',
    'medium',
    'hard'
  ];
  String currentDifficultyLevel;

  AlertDifficulty(String currentDifficultyLevel) {
    currentDifficultyLevel = currentDifficultyLevel;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Center(
          child: Text(
        'Select Difficulty Level',
      )),
      contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      children: <Widget>[
        for (String level in difficulties)
          Card(
            margin: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            elevation: 0,
            shape: const  RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SimpleDialogOption(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              onPressed: () {
                if (level != currentDifficultyLevel) {
                  setState(() {
                    difficulty = level;
                  });
                }
                Navigator.pop(context);
              },
              child: Text(
                level[0].toUpperCase() + level.substring(1),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          )
      ],
    );
  }
}

class AlertExit extends StatelessWidget {
  const AlertExit({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text(
        'Exit Game',
      ),
      content: const Text(
        'Are you sure you want to exit the game ?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}