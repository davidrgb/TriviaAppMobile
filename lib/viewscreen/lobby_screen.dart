import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trivia_app/controller/FirestoreController.dart';
import 'package:trivia_app/model/constant.dart';
import 'package:trivia_app/model/lobby.dart';
import 'package:trivia_app/model/player.dart';
import 'package:trivia_app/viewscreen/game_screen.dart';
import 'package:trivia_app/viewscreen/hi_lo_screen.dart';
import 'package:trivia_app/viewscreen/home_screen.dart';
import 'package:trivia_app/viewscreen/join_screen.dart';

class LobbyScreen extends StatefulWidget {
  static const routeName = 'lobbyScreen';

  const LobbyScreen(this.lobby, this.player, {Key? key}) : super(key: key);

  final Lobby lobby;
  final Player player;

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
      onWillPop: () => controller.leaveLobby(),
      child: Scaffold(
        appBar: AppBar(
          title: widget.lobby.id.compareTo(widget.player.id) == 0
              ? const Text('Press Start when ready')
              : const Text('Waiting for host to start'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 0; i < widget.lobby.players.length; i++)
                  Text(
                    widget.lobby.players[i]['name'],
                    style: const TextStyle(fontSize: 24),
                  ),
                widget.lobby.id.compareTo(widget.player.id) == 0
                    ? ElevatedButton(
                        onPressed: controller.start_lobby,
                        child: const Text(
                          'Start',
                        ),
                      )
                    : const SizedBox(
                        height: 1,
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
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listener;

  _Controller(this.state) {
    final reference = FirebaseFirestore.instance
        .collection(Constant.LOBBY_COLLECTION)
        .doc(state.widget.lobby.docId);
    listener = reference.snapshots().listen((event) {
      if (event.data() == null) {
        leaveOnDeletion();
      } else {
        var document = event.data() as Map<String, dynamic>;
        var l = Lobby.fromFirestoreDoc(doc: document, docId: event.id);
        if (l != null) state.widget.lobby.setProperties(l);
        state.render(() {});
        if (state.widget.lobby.open == false) enter_game();
      }
    });
  }

  void start_lobby() async {
    Map<String, dynamic> updateInfo = {};
    updateInfo[Lobby.OPEN] = false;
    await FirestoreController.updateLobby(
        docId: state.widget.lobby.docId!, updateInfo: updateInfo);
    enter_game();
  }

  void enter_game() async {
    listener.cancel();
    if (state.widget.lobby.category == Constant.HI_LO_MOVIES_CATEGORY) {
      await Navigator.pushNamed(state.context, HiLoScreen.routeName,
          arguments: {
            ARGS.LOBBY: state.widget.lobby,
            ARGS.PLAYER: state.widget.player,
          });
    } else {
      await Navigator.pushNamed(state.context, GameScreen.routeName,
          arguments: {
            ARGS.LOBBY: state.widget.lobby,
            ARGS.PLAYER: state.widget.player,
          });
    }
  }

  Future<bool> leaveLobby() async {
    listener.cancel();
    if (state.widget.lobby.id == state.widget.player.id) {
      await FirestoreController.deleteLobby(docId: state.widget.lobby.docId!);
      return true;
    } else {
      Map<String, dynamic> updateInfo = {};
      var players = [];
      for (var i = 0; i < state.widget.lobby.players.length; i++) {
        if (state.widget.lobby.players[i]['id'] != state.widget.player.id)
          players.add(state.widget.lobby.players[i]);
      }
      updateInfo[Lobby.PLAYERS] = players;
      await FirestoreController.updateLobby(
          docId: state.widget.lobby.docId!, updateInfo: updateInfo);
      await Navigator.pushNamed(
        state.context,
        HomeScreen.routeName,
      );
      return false;
    }
  }

  Future<void> leaveOnDeletion() async {
    listener.cancel();
    Navigator.pushNamed(
      state.context,
      HomeScreen.routeName,
    );
  }
}
