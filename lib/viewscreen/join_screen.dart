import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trivia_app/controller/FirestoreController.dart';
import 'package:trivia_app/model/constant.dart';
import 'package:trivia_app/model/lobby.dart';
import 'package:trivia_app/model/player.dart';
import 'package:trivia_app/viewscreen/lobby_screen.dart';

class JoinScreen extends StatefulWidget {
  static const routeName = '/joinScreen';

  const JoinScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  late _Controller controller;
  GlobalKey<FormState> playerNameKey = GlobalKey<FormState>();

  List<Lobby> lobbies = [];

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    controller = _Controller(this);
    controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join a Lobby'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: playerNameKey,
                child: TextFormField(
                  decoration: const InputDecoration(hintText: 'Your Name'),
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  validator: controller.validatePlayerName,
                  onSaved: controller.savePlayerName,
                ),
              ),
              for (int i = 0; i < lobbies.length; i++)
                ElevatedButton(
                  onPressed: () => controller.joinLobby(lobbies[i]),
                  child: Text(lobbies[i].name + ' | ' + lobbies[i].category),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  late _JoinScreenState state;
  _Controller(this.state);

  String? playerName;

  void refresh() async {
    state.lobbies = await FirestoreController.readLobbies();
    state.render(() {});
  }

  String? validatePlayerName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Player name required.';
    } else if (value.length > 20) {
      return 'Player name is too long';
    } else {
      return null;
    }
  }

  void savePlayerName(String? value) {
    if (value != null) playerName = value;
  }

  void joinLobby(Lobby lobby) async {
    FormState? currentState = state.playerNameKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    var rng = Random();
    String playerId = playerName.toString() + (rng.nextInt(999) + 1).toString();

    Map<String, dynamic> updateInfo = {};
    Player player = Player(
      name: playerName!,
      id: playerId,
      score: 0,
    );
    lobby.players.add(player.toFirestoreDoc());
    updateInfo[Lobby.PLAYERS] = lobby.players;
    await FirestoreController.updateLobby(
        docId: lobby.docId!, updateInfo: updateInfo);
    await Navigator.pushNamed(
      state.context,
      LobbyScreen.routeName,
      arguments: {
        ARGS.LOBBY: lobby,
        ARGS.PLAYER: player,
      },
    );
  }
}
