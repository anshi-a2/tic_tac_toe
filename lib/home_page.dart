import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/game_button.dart';
import 'package:tic_tac_toe_flutter/winner_dialog.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameButton> buttonsList;
  var device, user, activePlayer;

  @override
  void initState() {
    super.initState();
    buttonsList = doInit();
  }

  List<GameButton> doInit() {
    device = new List();
    user = new List();
    activePlayer = 1;

    var gameButtons = <GameButton>[
      new GameButton(id: 1),
      new GameButton(id: 2),
      new GameButton(id: 3),
      new GameButton(id: 4),
      new GameButton(id: 5),
      new GameButton(id: 6),
      new GameButton(id: 7),
      new GameButton(id: 8),
      new GameButton(id: 9),
    ];

    return gameButtons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (activePlayer == 1) {
        gb.text = "X";
        gb.bg = Colors.cyan;
        activePlayer = 2;
        device.add(gb.id);
      } else {
        gb.text = "O";
        gb.bg = Colors.pinkAccent;
        activePlayer = 1;
        user.add(gb.id);
      }
      gb.enabled = false;
      int winner = checkWinner();
      if (winner == -1) {
        if (buttonsList.every((p) => p.text != "")) {
          showDialog(
              context: context,
              builder: (_) => new WinnerDialog("Game Tied",
                  "Press the reset button to start again.", resetGame));
        } else {
          if (activePlayer == 2) {
            autoPlay();
          }
          // activePlayer == 2 ? autoPlay() : null;
        }
      }
    });
  }

  void autoPlay() {
    var emptyCells = new List();
    var list = new List.generate(9, (i) => i + 1);
    for (var cellId in list) {
      if (!(device.contains(cellId) || user.contains(cellId))) {
        emptyCells.add(cellId);
      }
    }

    var r = new Random();
    var randIndex = r.nextInt((emptyCells.length - 1));
    var cellId = emptyCells[randIndex];
    int i = buttonsList.indexWhere((element) => element.id == cellId);
    playGame(buttonsList[i]);
  }

  int checkWinner() {
    var winner = -1;

    //row1
    if (device.contains(1) && device.contains(2) && device.contains(3)) {
      winner = 1;
    }

    if (user.contains(1) && user.contains(2) && user.contains(3)) {
      winner = 2;
    }

    //row2
    if (device.contains(4) && device.contains(5) && device.contains(6)) {
      winner = 1;
    }
    if (user.contains(4) && user.contains(5) && user.contains(6)) {
      winner = 2;
    }

    //row3
    if (device.contains(7) && device.contains(8) && device.contains(9)) {
      winner = 1;
    }
    if (user.contains(7) && user.contains(8) && user.contains(9)) {
      winner = 2;
    }

    //col1
    if (device.contains(1) && device.contains(4) && device.contains(7)) {
      winner = 1;
    }
    if (user.contains(1) && user.contains(4) && user.contains(7)) {
      winner = 2;
    }

    //col2
    if (device.contains(2) && device.contains(5) && device.contains(8)) {
      winner = 1;
    }
    if (user.contains(2) && user.contains(5) && user.contains(8)) {
      winner = 2;
    }

    //col3
    if (device.contains(3) && device.contains(6) && device.contains(9)) {
      winner = 1;
    }
    if (user.contains(3) && user.contains(6) && user.contains(9)) {
      winner = 2;
    }

    //diag1
    if (device.contains(1) && device.contains(5) && device.contains(9)) {
      winner = 1;
    }
    if (user.contains(1) && user.contains(5) && user.contains(9)) {
      winner = 2;
    }

    //diag2
    if (device.contains(3) && device.contains(5) && device.contains(7)) {
      winner = 1;
    }
    if (user.contains(3) && user.contains(5) && user.contains(7)) {
      winner = 2;
    }

    if (winner != -1) {
      if (winner == 1) {
        showDialog(
            context: context,
            builder: (_) => new WinnerDialog("Player Won",
                " Press the reset button to start again", resetGame));
      } else {
        showDialog(
            context: context,
            builder: (_) => new WinnerDialog("Computer Won",
                " Press the reset button to start again", resetGame));
      }
    }

    return winner;
  }

  void resetGame() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    setState(() {
      buttonsList = doInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("tic tac toe game"),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Expanded(
            child: new GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 9.0,
                mainAxisSpacing: 9.0,
              ),
              itemCount: buttonsList.length,
              itemBuilder: (context, i) => new SizedBox(
                width: 100.0,
                height: 100.0,
                child: new RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  onPressed: buttonsList[i].enabled
                      ? () => playGame(buttonsList[i])
                      : null,
                  child: new Text(
                    buttonsList[i].text,
                    style: new TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  color: buttonsList[i].bg,
                  disabledColor: buttonsList[i].bg,
                ),
              ),
            ),
          ),
          new RaisedButton(
            child: new Text(
              "Reset",
              style: new TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            color: Colors.red,
            padding: const EdgeInsets.all(20.0),
            onPressed: resetGame,
          )
        ],
      ),
    );
  }
}
