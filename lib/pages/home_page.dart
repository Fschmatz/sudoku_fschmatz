import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:sudoku_fschmatz/pages/alerts.dart';
import 'package:sudoku_fschmatz/pages/configs/settings_page.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool firstRun = true;
  bool gameOver = false;
  int timesCalled = 0;
  bool isButtonDisabled = false;
  List<List<List<int>>> gameList;
  List<List<int>> game;
  List<List<int>> gameCopy;
  List<List<int>> gameSolved;
  static String currentDifficultyLevel;
  double buttonGridFontSize = 18;
  double buttonGridSize = 43;
  List<int> listNumberButtons = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
  int selectedNumber;

  //NUMBER BUTTONS
  TextStyle styleSelectedButtonNumber =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle styleUnselectedButtonNumber =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.w700);


  @override
  void initState() {
    super.initState();

    getPrefs().whenComplete(() {
      if (currentDifficultyLevel == null) {
        currentDifficultyLevel = 'easy';
        setPrefs('currentDifficultyLevel');
      }
      newGame(currentDifficultyLevel);
    });
    
  }

  Future<void> getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentDifficultyLevel = prefs.getString('currentDifficultyLevel');
    });
  }

  setPrefs(String property) async {
    final prefs = await SharedPreferences.getInstance();
    if (property == 'currentDifficultyLevel') {
      prefs.setString('currentDifficultyLevel', currentDifficultyLevel);
    }
  }

  void checkResult() {
    try {
      if (SudokuUtilities.isSolved(game)) {
        isButtonDisabled = !isButtonDisabled;
        gameOver = true;
        Timer(const Duration(milliseconds: 500), () {
          showAnimatedDialog<void>(
              animationType: DialogTransitionType.fadeScale,
              barrierDismissible: true,
              duration: const Duration(milliseconds: 350),
              context: context,
              builder: (_) => AlertGameOver()).whenComplete(() {
            if (AlertGameOver.newGame) {
              newGame();
              AlertGameOver.newGame = false;
            }
          });
        });
      }
    } on InvalidSudokuConfigurationException {
      return;
    }
  }

  static List<List<List<int>>> getNewGame([String difficulty = 'easy']) {
    int emptySquares;
    switch (difficulty) {
      case 'test':
        {
          emptySquares = 2;
        }
        break;
      case 'beginner':
        {
          emptySquares = 18;
        }
        break;
      case 'easy':
        {
          emptySquares = 27;
        }
        break;
      case 'medium':
        {
          emptySquares = 36;
        }
        break;
      case 'hard':
        {
          emptySquares = 54;
        }
        break;
    }
    SudokuGenerator generator = SudokuGenerator(emptySquares: emptySquares);
    return [generator.newSudoku, generator.newSudokuSolved];
  }

  void setGame(int mode, [String difficulty = 'easy']) {
    if (mode == 1) {
      game = List.generate(9, (i) => [0, 0, 0, 0, 0, 0, 0, 0, 0]);
      gameCopy = SudokuUtilities.copySudoku(game);
      gameSolved = SudokuUtilities.copySudoku(game);
    } else {
      gameList = getNewGame(difficulty);
      game = gameList[0];
      gameCopy = SudokuUtilities.copySudoku(game);
      gameSolved = gameList[1];
    }
  }

  void showSolution() {
    setState(() {
      game = SudokuUtilities.copySudoku(gameSolved);
      isButtonDisabled =
          !isButtonDisabled ? !isButtonDisabled : isButtonDisabled;
      gameOver = true;
    });
  }

  void newGame([String difficulty = 'easy']) {
    setState(() {
      setGame(2, difficulty);
      isButtonDisabled =
          isButtonDisabled ? !isButtonDisabled : isButtonDisabled;
      gameOver = false;
    });
  }

  Color buttonColor(int k, int i) {
    Color color;
    if (([0, 1, 2].contains(k) && [3, 4, 5].contains(i)) ||
        ([3, 4, 5].contains(k) && [0, 1, 2, 6, 7, 8].contains(i)) ||
        ([6, 7, 8].contains(k) && [3, 4, 5].contains(i))) {
      color = Theme.of(context).cardTheme.color; // fundo grid cor
    }
    return color;
  }

  BorderRadiusGeometry buttonEdgeRadius(int k, int i) {
    if (k == 0 && i == 0) {
      return const BorderRadius.only(topLeft: Radius.circular(8));
    } else if (k == 0 && i == 8) {
      return const BorderRadius.only(topRight: Radius.circular(8));
    } else if (k == 8 && i == 0) {
      return const BorderRadius.only(bottomLeft: Radius.circular(8));
    } else if (k == 8 && i == 8) {
      return const BorderRadius.only(bottomRight: Radius.circular(8));
    }
    return BorderRadius.circular(0);
  }

  List<SizedBox> createButtons() {
    if (firstRun) {
      setGame(1);
      firstRun = false;
    }

    List<SizedBox> buttonList = List<SizedBox>.filled(9, null);
    for (var i = 0; i <= 8; i++) {
      var k = timesCalled;
      buttonList[i] = SizedBox(
        width: buttonGridSize,
        height: buttonGridSize,
        child: TextButton(
          onPressed: isButtonDisabled || gameCopy[k][i] != 0
              ? null
              : () {
                  if (selectedNumber != 0) {
                    callback([k, i], selectedNumber);
                  } else {
                    callback([k, i], 0);
                  }
                },
          onLongPress: isButtonDisabled || gameCopy[k][i] != 0
              ? null
              : () => callback([k, i], 0),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(buttonColor(k, i)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
              borderRadius: buttonEdgeRadius(k, i),
            )),
            side: MaterialStateProperty.all<BorderSide>(const BorderSide(
              width: 0.7,
              color: Color(0xFF404042),
              style: BorderStyle.solid,
            )),
          ),
          child: Text(
            game[k][i] != 0 ? game[k][i].toString() : ' ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: buttonGridFontSize,
            ),
          ),
        ),
      );
    }
    timesCalled++;
    if (timesCalled == 9) {
      timesCalled = 0;
    }
    return buttonList;
  }

  Row oneRow() {
    return Row(
      children: createButtons(),
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  List<Row> createRows() {
    List<Row> rowList = List<Row>.filled(9, null);
    for (var i = 0; i <= 8; i++) {
      rowList[i] = oneRow();
    }
    return rowList;
  }

  void callback(List<int> index, int number) {
    setState(() {
      if (number == null) {
        return;
      } else if (number == 0) {
        game[index[0]][index[1]] = number;
      } else {
        game[index[0]][index[1]] = number;
        checkResult();
      }
    });
  }

  showOptionsBottomMenu(BuildContext context) {
    BuildContext outerContext = context;
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (context) {
          const TextStyle customStyle = TextStyle(
            fontSize: 15
          );
          return Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.add_rounded,
                ),
                title: const Text('New Game', style: customStyle),
                onTap: () {
                  Navigator.pop(context);
                  Timer(const Duration(milliseconds: 200),
                      () => newGame(currentDifficultyLevel));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.lightbulb_outline_rounded,
                ),
                title: const Text('Show Solution', style: customStyle),
                onTap: () {
                  Navigator.pop(context);
                  Timer(
                      const Duration(milliseconds: 200), () => showSolution());
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.build_outlined,
                  size: 23,
                ),
                title: const Text('Set Difficulty', style: customStyle),
                onTap: () {
                  Navigator.pop(context);
                  Timer(
                      const Duration(milliseconds: 300),
                      () => showAnimatedDialog<void>(
                              animationType: DialogTransitionType.fadeScale,
                              barrierDismissible: true,
                              duration: const Duration(milliseconds: 350),
                              context: outerContext,
                              builder: (_) => AlertDifficultyState(
                                  currentDifficultyLevel)).whenComplete(() {
                            if (AlertDifficultyState.difficulty != null) {
                              Timer(const Duration(milliseconds: 300), () {
                                newGame(AlertDifficultyState.difficulty);
                                currentDifficultyLevel =
                                    AlertDifficultyState.difficulty;
                                AlertDifficultyState.difficulty = null;
                                setPrefs('currentDifficultyLevel');
                              });
                            }
                          }));
                },
              ),
            ],
          );
        });
  }

  Widget buttonsList() {

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 0),
      child: Column(
        children: [
          GridView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: 5,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1.5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 15,
              ),
              itemBuilder: (BuildContext context, int index) {
                return TextButton(
                  key: UniqueKey(),
                  onPressed: () {
                    setState(() {
                      selectedNumber = listNumberButtons[index];
                    });
                  },
                  child: Text(
                    listNumberButtons[index].toString(),
                  ),
                  style: ElevatedButton.styleFrom(
                    textStyle: selectedNumber == listNumberButtons[index]
                        ? styleSelectedButtonNumber
                        : styleUnselectedButtonNumber,
                    elevation: 0,
                    primary: selectedNumber == listNumberButtons[index]
                        ? Theme.of(context).accentColor.withOpacity(0.3)
                        : Theme.of(context).cardTheme.color,
                    onPrimary: selectedNumber == listNumberButtons[index]
                        ?  Theme.of(context).accentColor
                        : Theme.of(context).textTheme.headline1.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }),
          const SizedBox(
            height: 20,
          ),
          GridView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: 5,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1.5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 15,
              ),
              itemBuilder: (BuildContext context, int index) {
                return TextButton(
                  key: UniqueKey(),
                  onPressed: () {
                    setState(() {
                      selectedNumber = listNumberButtons[index + 5];
                    });
                  },
                  child: listNumberButtons[index + 5] == 0
                      ? const Icon(Icons.highlight_remove_outlined)
                      : Text(
                          listNumberButtons[index + 5].toString(),
                        ),
                  style: ElevatedButton.styleFrom(
                    textStyle: selectedNumber == listNumberButtons[index + 5]
                        ? styleSelectedButtonNumber
                        : styleUnselectedButtonNumber,
                    elevation: 0,
                    primary: selectedNumber == listNumberButtons[index + 5]
                        ? Theme.of(context).accentColor.withOpacity(0.3)
                        : Theme.of(context).cardTheme.color,
                    onPrimary: selectedNumber == listNumberButtons[index + 5]
                        ?  Theme.of(context).accentColor
                        : Theme.of(context).textTheme.headline1.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
          showAnimatedDialog<void>(
              animationType: DialogTransitionType.fadeScale,
              barrierDismissible: true,
              duration: const Duration(milliseconds: 350),
              context: context,
              builder: (_) => const AlertExit());
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Sudoku Fschmatz'),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: Theme.of(context)
                        .textTheme
                        .headline6
                        .color
                        .withOpacity(0.8),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const SettingsPage(),
                          fullscreenDialog: true,
                        ));
                  }),
            ],
          ),
          body: Builder(builder: (builder) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 90, 0, 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: createRows(),
                  ),
                ),
                buttonsList()
              ],
            );
          }),
          bottomNavigationBar: BottomAppBar(
              elevation: 0,
              child: IconButton(
                  splashRadius: 30,
                  icon: Icon(
                    Icons.menu_outlined,
                    size: 25,
                    color: Theme.of(context)
                        .textTheme
                        .headline6
                        .color
                        .withOpacity(0.8),
                  ),
                  onPressed: () {
                    showOptionsBottomMenu(context);
                  })),
        ));
  }
}
