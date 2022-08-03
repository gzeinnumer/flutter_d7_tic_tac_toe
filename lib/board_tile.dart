import 'package:flutter/material.dart';
import 'package:flutter_d7_tic_tac_toe/tile_state.dart';

class BoardTile extends StatelessWidget {
  const BoardTile({
    Key? key,
    required this.tileDimension,
    this.onPressed,
    this.tileState,
  }) : super(key: key);

  final TileState? tileState;
  final double tileDimension;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tileDimension,
      height: tileDimension,
      child: FlatButton(
        onPressed: onPressed,
        child: _widgetForTileState(),
      ),
    );
  }

  Widget _widgetForTileState() {
    Widget widget = Container();

    switch (tileState) {
      case TileState.EMPTY:
        widget = Container();
        break;
      case TileState.CROSS:
        widget = Image.asset('images/x.png');
        break;
      case TileState.CIRCLE:
        widget = Image.asset('images/o.png');
        break;
      default:
        widget = Container();
        break;
    }
    return widget;
  }
}
