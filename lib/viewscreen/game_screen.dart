import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trivia_app/controller/FirestoreController.dart';
import 'package:trivia_app/model/lobby.dart';
import 'package:trivia_app/model/player.dart';
import 'package:trivia_app/viewscreen/home_screen.dart';

import '../model/constant.dart';

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

  GlobalKey<FormState> answerKey = GlobalKey<FormState>();

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    controller = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.leave(),
      child: Scaffold(
        appBar: AppBar(
          title: (widget.lobby.state == 0
              ? widget.player.id.compareTo(widget
                          .lobby
                          .players[widget.lobby.playerIndex %
                              widget.lobby.players.length]['id']
                          .toString()) ==
                      0
                  ? const Text('Reveal a tile')
                  : const Text('Waiting for another player')
              : widget.lobby.state == 1
                  ? const Text('Guess')
                  : widget.lobby.state == 2
                      ? const Text('Get ready for the next question')
                      : const Text('Game Over')),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: widget.lobby.questions.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        widget.lobby.state == 2
                            ? widget.lobby.questions[0]['answer']
                            : '?',
                        style: const TextStyle(fontSize: 24),
                      ),
                      Text(
                        widget.lobby.questions[0]['info'],
                        style: const TextStyle(fontSize: 24),
                      ),
                      widget.lobby.state == 1 &&
                              (controller.answer == null ||
                                  controller.answer.length < 1)
                          ? Form(
                              key: answerKey,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: 'What is it?'),
                                  keyboardType: TextInputType.name,
                                  autocorrect: false,
                                  onFieldSubmitted: (value) {
                                    controller.guess_answer();
                                  },
                                  validator: controller.validateAnswer,
                                  onSaved: controller.saveAnswer,
                                  autofocus: true,
                                ),
                              ),
                            )
                          : const SizedBox(
                              height: 1,
                            ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0;
                                i < widget.lobby.players.length;
                                i++)
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  primary: widget.lobby.playerIndex %
                                              widget.lobby.players.length ==
                                          i
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                child: Text(
                                    '${widget.lobby.players[i]['name']}: ${widget.lobby.players[i]['score']}'),
                              ),
                          ],
                        ),
                      ),
                      for (int i = 0;
                          i < widget.lobby.questions[0]['fields'].length;
                          i++)
                        Column(
                          children: [
                            Text(
                              widget.lobby.questions[0]['fields'][i]['name'],
                              style: const TextStyle(fontSize: 24),
                            ),
                            for (int j = 0;
                                j <
                                    widget
                                        .lobby
                                        .questions[0]['fields'][i]['data']
                                        .length;
                                j++)
                              ElevatedButton(
                                onPressed: widget.lobby.players[widget
                                                        .lobby.playerIndex %
                                                    widget.lobby.players.length]
                                                ['name'] !=
                                            widget.player.name ||
                                        widget.lobby.questions[0]['fields'][i]
                                            ['data'][j]['revealed'] ||
                                        widget.lobby.state != 0
                                    ? () {}
                                    : () => {controller.reveal_tile(i, j)},
                                child: Text(
                                  widget.lobby.questions[0]['fields'][i]['data']
                                          [j]['revealed']
                                      ? widget.lobby.questions[0]['fields'][i]
                                          ['data'][j]['data']
                                      : '?',
                                ),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                    ],
                  )
                : Column(
                    children: [
                      const Text(
                        'Final Score',
                        style: TextStyle(fontSize: 36),
                      ),
                      for (int i = 0; i < widget.lobby.players.length; i++)
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            '${widget.lobby.players[i]['name']}: ${widget.lobby.players[i]['score']}',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

AlertDialog _popupDialog(
    BuildContext context, bool correct, bool over, String answer) {
  return AlertDialog(
      title: correct
          ? const Text('Correct!')
          : over
              ? const Text('Better luck next time')
              : const Text('No one got the answer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          over
              ? Text('The answer is $answer')
              : const Text('You have another chance')
        ],
      ));
}

class _Controller {
  late _GameScreenState state;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listener;
  String answer = "";
  String lastQuestionAnswer = "";

  _Controller(this.state) {
    final reference = FirebaseFirestore.instance
        .collection(Constant.LOBBY_COLLECTION)
        .doc(state.widget.lobby.docId);
    listener = reference.snapshots().listen((event) {
      var document = event.data() as Map<String, dynamic>;
      var l = Lobby.fromFirestoreDoc(doc: document, docId: event.id);
      if (l != null) state.widget.lobby.setProperties(l);
      if (state.widget.lobby.state == 0) {
        lastQuestionAnswer = state.widget.lobby.questions[0]['answer'];
        if (answer.isNotEmpty) {
          showDialog(
              context: state.context,
              builder: (BuildContext context) {
                return _popupDialog(
                    context,
                    answer
                            .toLowerCase()
                            .compareTo(lastQuestionAnswer.toLowerCase()) ==
                        0,
                    false,
                    lastQuestionAnswer);
              });
        }
        answer = "";
      }
      if (state.widget.lobby.state == 2) {
        if (answer.isNotEmpty) {
          showDialog(
              context: state.context,
              builder: (BuildContext context) {
                return _popupDialog(
                    context,
                    answer
                            .toLowerCase()
                            .compareTo(lastQuestionAnswer.toLowerCase()) ==
                        0,
                    true,
                    lastQuestionAnswer);
              });
        }
      }
      if (state.widget.player.id.compareTo(state.widget.lobby.id) == 0 &&
          state.widget.lobby.state == 1 &&
          state.widget.lobby.answers.length ==
              state.widget.lobby.players.length) {
        var correctAnswer = false;
        for (var answer in state.widget.lobby.answers) {
          if (answer['answer'].toString().toLowerCase().compareTo(state
                  .widget.lobby.questions[0]['answer']
                  .toString()
                  .toLowerCase()) ==
              0) correctAnswer = true;
        }
        var noTiles = true;
        for (var field in state.widget.lobby.questions[0]['fields']) {
          for (var data in field['data']) {
            if (data['revealed'] == false) noTiles = false;
          }
        }
        Map<String, dynamic> updateInfo = {};
        updateInfo[Lobby.PLAYER_INDEX] = state.widget.lobby.playerIndex + 1;
        if (correctAnswer || noTiles) {
          updateInfo[Lobby.STATE] = 2;
        } else {
          state.widget.lobby.answers.clear();
          updateInfo[Lobby.STATE] = 0;
          updateInfo[Lobby.ANSWERS] = state.widget.lobby.answers;
        }
        FirestoreController.updateLobby(
            docId: state.widget.lobby.docId!, updateInfo: updateInfo);
      } else if (state.widget.player.id.compareTo(state.widget.lobby.id) == 0 &&
          state.widget.lobby.state == 2) {
        for (var answer in state.widget.lobby.answers) {
          if (answer['answer'].toString().toLowerCase().compareTo(state
                  .widget.lobby.questions[0]['answer']
                  .toString()
                  .toLowerCase()) ==
              0) {
            for (var player in state.widget.lobby.players) {
              if (player['id'].toString().compareTo(answer['id'].toString()) ==
                  0) player['score']++;
            }
          }
        }
        state.widget.lobby.answers.clear();
        Map<String, dynamic> updateInfo = {};
        state.widget.lobby.questions.removeAt(0);
        updateInfo[Lobby.QUESTIONS] = state.widget.lobby.questions;
        updateInfo[Lobby.PLAYERS] = state.widget.lobby.players;
        updateInfo[Lobby.ANSWERS] = state.widget.lobby.answers;
        if (state.widget.lobby.questions.isEmpty) {
          updateInfo[Lobby.STATE] = 3;
        } else {
          updateInfo[Lobby.STATE] = 0;
        }
        FirestoreController.updateLobby(
            docId: state.widget.lobby.docId!, updateInfo: updateInfo);
      } else if (state.widget.lobby.state == 3) {
        state.widget.lobby.players
            .sort((a, b) => b['score'].compareTo(a['score']));
        listener.cancel();
      }
      state.render(() {});
    });
  }

  void reveal_tile(field, data) async {
    Map<String, dynamic> updateInfo = {};
    state.widget.lobby.questions[0]['fields'][field]['data'][data]['revealed'] =
        true;
    updateInfo[Lobby.QUESTIONS] = state.widget.lobby.questions;
    updateInfo[Lobby.STATE] = 1;
    await FirestoreController.updateLobby(
        docId: state.widget.lobby.docId!, updateInfo: updateInfo);
    state.render(() => {});
  }

  String? validateAnswer(String? value) {
    if (value == null || value.length < 1) {
      return 'Please enter an answer';
    } else {
      return null;
    }
  }

  void saveAnswer(String? value) {
    if (value != null) answer = value;
  }

  void guess_answer() async {
    FormState? currentState = state.answerKey.currentState;
    if (currentState == null || !currentState.validate()) return;

    currentState.save();
    currentState.reset();

    Map<String, dynamic> updateInfo = {};
    state.widget.lobby.answers.add({
      "id": state.widget.player.id,
      "answer": answer,
    });
    updateInfo[Lobby.ANSWERS] = state.widget.lobby.answers;
    await FirestoreController.updateLobby(
        docId: state.widget.lobby.docId!, updateInfo: updateInfo);
  }

  Future<bool> leave() async {
    if (state.widget.lobby.state == 3) {
      if (state.widget.lobby.id.toString().compareTo(state.widget.player.id) ==
          0) {
        await FirestoreController.deleteLobby(docId: state.widget.lobby.docId!);
      }
      await Navigator.pushNamed(
        state.context,
        HomeScreen.routeName,
      );
    }
    return false;
  }
}
