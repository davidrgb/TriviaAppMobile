import 'package:flutter/material.dart';
import 'package:trivia_app/controller/FirestoreController.dart';
import 'package:trivia_app/model/lobby.dart';
import 'package:trivia_app/model/field.dart';
import 'package:trivia_app/model/question.dart';
import 'package:trivia_app/viewscreen/GameScreen.dart';

class LobbyScreen extends StatefulWidget {
  static const routeName = 'lobbyScreen';

  const LobbyScreen(this.lobby, {Key? key}) : super(key: key);

  final Lobby lobby;

  @override
  State<StatefulWidget> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late _Controller controller;

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    controller = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.host_leave(),
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 0; i < widget.lobby.players.length; i++)
                  Text(widget.lobby.players[i]['name']),
                ElevatedButton(
                  onPressed: controller.start_lobby,
                  child: Text('Start'),
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
  late _LobbyScreenState state;
  _Controller(this.state);

  void start_lobby() async {
    Map<String, dynamic> updateInfo = {};
    updateInfo[Lobby.OPEN] = false;
    await FirestoreController.updateLobby(
        docId: state.widget.lobby.docId!, updateInfo: updateInfo);
    enter_game();
  }

  void enter_game() async {
    await Navigator.pushNamed(
      state.context,
      GameScreen.routeName,
      arguments: state.widget.lobby,
    );
  }

  Future<bool> host_leave() async {
    await FirestoreController.deleteLobby(docId: state.widget.lobby.docId!);
    return true;
  }
}
