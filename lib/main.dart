import 'package:flutter/material.dart';
import 'package:flutter_d7_tic_tac_toe/tile_state.dart';

import 'board_tile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  var _boardState = List.filled(9, TileState.EMPTY);

  //[ [1,2,3] , [4,5,6] , [7,8,9] ]

  var _currentTurn = TileState.CROSS;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Stack(
              children: [Image.asset('images/board.png'), _boardTiles()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _boardTiles() {
    return Builder(builder: (context) {
      final boardDimension = MediaQuery.of(context).size.width;
      final tileDimension = boardDimension / 3;
      return Container(
        width: boardDimension,
        height: boardDimension,
        child: Column(
          children: chunk(_boardState, 3).asMap().entries.map((entry) {
            final chunkIndex = entry.key;
            final tileStateChunk = entry.value; //this is array //[[1,2,3]]

            return Row(
              children: tileStateChunk.asMap().entries.map((innerEnty) {
                final innerIndex = innerEnty.key;
                final tileState = innerEnty.value;
                final tileIndex = (chunkIndex * 3) + innerIndex; //[[1]]

                return BoardTile(
                  tileDimension: tileDimension,
                  tileState: tileState,
                  onPressed: () => _updateTileStateForIndex(tileIndex),
                );
              }).toList(),
            );
          }).toList(),
        ),
      );
    });
  }

  void _updateTileStateForIndex(int selectedIndex) {
    if (_boardState[selectedIndex] == TileState.EMPTY) {
      setState(() {
        _boardState[selectedIndex] = _currentTurn;
        _currentTurn = _currentTurn == TileState.CROSS
            ? TileState.CIRCLE
            : TileState.CROSS;
      });

      final winner = _findWinner();
      if (winner != null) {
        print('Winner is: $winner');
        _showWinnerDialog(winner);
      }
    }
  }

  TileState? _findWinner() {
    TileState? Function(int, int, int) winnerForMatch = (a, b, c) {
      if (_boardState[a] != TileState.EMPTY) {
        if ((_boardState[a] == _boardState[b]) &&
            (_boardState[b] == _boardState[c])) {
          return _boardState[a];
        }
      }
      return null;
    };

    final checks = [
      winnerForMatch(0, 1, 2),
      winnerForMatch(3, 4, 5),
      winnerForMatch(6, 7, 8),
      winnerForMatch(0, 3, 6),
      winnerForMatch(1, 4, 7),
      winnerForMatch(2, 5, 8),
      winnerForMatch(0, 4, 8),
      winnerForMatch(2, 4, 6),
    ];

    TileState? winner;
    for (int i = 0; i < checks.length; i++) {
      if (checks[i] != null) {
        winner = checks[i]!;
        break;
      }
    }

    return winner;
  }

  void _showWinnerDialog(TileState tileState) {
    final context = navigatorKey.currentState!.overlay!.context;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Winner'),
            content: Image.asset(
              tileState == TileState.CROSS ? 'images/x.png' : 'images/o.png',
            ),
            actions: [
              FlatButton(onPressed: (){
                _resetGame();
                 Navigator.of(context).pop();
              }, child: const Text('New Game'),),
            ],
          );
        });
  }

  void _resetGame(){
    setState(() {
      _boardState = List.filled(9, TileState.EMPTY);
      _currentTurn = TileState.CROSS;
    });
  }
}
