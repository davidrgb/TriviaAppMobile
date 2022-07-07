import 'package:flutter/material.dart';
import 'package:trivia_app/model/lobby.dart';
import 'package:trivia_app/model/player.dart';

class GameScreen extends StatefulWidget {
  static const routeName = 'gameScreen';

  const GameScreen(this.lobby, this.player, {Key? key}) : super(key: key);

  final Lobby lobby;
  final Player player;

  @override
  State<StatefulWidget> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late _Controller controller;
  List<List<bool>> tiles_revealed = [[]];

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    controller = _Controller(this);
    var fields = widget.lobby.questions[0]['fields'];
    for (int i = 0; i < fields.length; i++) {
      tiles_revealed.add([]);
      var data = fields[i]['data'];
      for (int j = 0; j < data.length; j++) {
        tiles_revealed[i].add(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(widget.lobby.questions[0]['answer']),
                Text(widget.lobby.questions[0]['info']),
                for (int i = 0; i < widget.lobby.questions[0]['fields'].length; i++)
                  Column(
                    children: [
                      Text(widget.lobby.questions[0]['fields'][i]['name']),
                      for (int j = 0; j < widget.lobby.questions[0]['fields'][i]['data'].length; j++)
                        ElevatedButton(
                          onPressed: tiles_revealed[i][j]
                              ? () {}
                              : () => {controller.reveal_tile(i, j)},
                          child: Text(
                            tiles_revealed[i][j]
                                ? widget.lobby.questions[0]['fields'][i]['data'][j]
                                : '?',
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  late _GameScreenState state;
  _Controller(this.state);

  void reveal_tile(field, data) async {
    state.tiles_revealed[field][data] = true;
    state.render(() => {});
  }

  void guess_answer() async {}

  void reset_screen() async {}
}
