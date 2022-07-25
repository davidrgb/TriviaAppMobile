import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trivia_app/controller/FirestoreController.dart';
import 'package:trivia_app/model/lobby.dart';
import 'package:trivia_app/model/player.dart';
import 'package:trivia_app/viewscreen/home_screen.dart';

import '../model/constant.dart';

class HiLoScreen extends StatefulWidget {
  static const routeName = 'hiLoScreen';

  const HiLoScreen(this.lobby, this.player, {Key? key}) : super(key: key);

  final Lobby lobby;
  final Player player;

  @override
  State<StatefulWidget> createState() => _HiLoScreenState();
}

class _HiLoScreenState extends State<HiLoScreen> {
  late _Controller controller;
  List<bool> playerAnswers = [];

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
          title: (widget.lobby.state != 3
              ? controller.answer >= 0 && controller.answer <= 2
                  ? const Text('Waiting on other players')
                  : const Text('Which has the higher rating?')
              : const Text('Game Over')),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _helpDialog(
                        context,
                        controller,
                      );
                    });
              },
              icon: const Icon(Icons.question_mark),
            ),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          child: widget.lobby.questions.isNotEmpty &&
                  widget.lobby.questions.length >= 2
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < widget.lobby.players.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    primary: playerAnswers.isNotEmpty &&
                                            playerAnswers[i]
                                        ? Colors.red
                                        : Colors.orange),
                                child: Text(
                                    '${widget.lobby.players[i]['name']}: ${widget.lobby.players[i]['score']}'),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => controller.guessAnswer(0),
                          style: ElevatedButton.styleFrom(
                              primary: controller.answer >= 0 &&
                                      controller.answer <= 2
                                  ? controller.answer == 0
                                      ? Colors.red
                                      : Colors.grey
                                  : Colors.red),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                Text(widget.lobby.questions[0]['answer']),
                                const Divider(
                                  thickness: 2,
                                  color: Colors.white,
                                ),
                                Text(widget.lobby.questions[0]['info']),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: controller.answer >= 0 &&
                                      controller.answer <= 2
                                  ? controller.answer == 1
                                      ? Colors.red
                                      : Colors.grey
                                  : Colors.red),
                          onPressed: () => controller.guessAnswer(1),
                          child: const Text("="),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: controller.answer >= 0 &&
                                      controller.answer <= 2
                                  ? controller.answer == 2
                                      ? Colors.red
                                      : Colors.grey
                                  : Colors.red),
                          onPressed: () => controller.guessAnswer(2),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                Text(widget.lobby.questions[1]['answer']),
                                const Divider(
                                  thickness: 2,
                                  color: Colors.white,
                                ),
                                Text(widget.lobby.questions[1]['info']),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 80,
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
    );
  }
}

AlertDialog _helpDialog(BuildContext context, _Controller controller) {
  return AlertDialog(
      title: const Text('How To Play'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'The goal of the game is to guess which of the items has the higher rating.',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Each turn, players will select the button of the item they believe has the higher rating, or the equal button if they believe they are the same.',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Players who guess correctly get a point and the game progresses to the next question.',
              style: const TextStyle(fontSize: 18),
            ),
            const Divider(
              thickness: 2,
              color: Colors.white,
            ),
            ElevatedButton(
              onPressed: () => controller.resetListener(context),
              child: const Text('Refresh'),
            ),
          ],
        ),
      ));
}

AlertDialog _popupDialog(
  BuildContext context,
  bool correct,
  bool over,
  String firstName,
  double firstRating,
  String secondName,
  double secondRating,
  var playerAnswer,
) {
  return AlertDialog(
      title: correct
          ? const Text('Correct!')
          : const Text('Better luck next time'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Text(
                '$firstName | $firstRating',
                style: const TextStyle(fontSize: 18),
              ),
              const Divider(
                thickness: 2,
                color: Colors.white,
              ),
              Text(
                '$secondName | $secondRating.',
                style: const TextStyle(fontSize: 18),
              ),
              const Divider(
                thickness: 2,
                color: Colors.white,
              ),
              for (var i = 0; i < playerAnswer.length; i++)
                Text(
                  '${playerAnswer[i]['name']} | ${playerAnswer[i]['answer'].toString().compareTo('0') == 0 ? firstName : playerAnswer[i]['answer'].toString().compareTo('2') == 0 ? secondName : '='}',
                  style: const TextStyle(fontSize: 18),
                )
            ],
          )
        ],
      ));
}

class _Controller {
  late _HiLoScreenState state;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listener;
  int answer = -1;
  int correctAnswer = 0;
  String lastQuestionFirstName = "";
  double lastQuestionFirstRating = 0;
  String lastQuestionSecondName = "";
  double lastQuestionSecondRating = 0;
  var storedAnswers;

  _Controller(this.state) {
    listenerFunction();
  }

  void guessAnswer(int answer) async {
    this.answer = answer;
    Map<String, dynamic> updateInfo = {};
    state.widget.lobby.answers.add({
      "id": state.widget.player.id,
      "name": state.widget.player.name,
      "answer": answer.toString(),
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

  void listenerFunction() {
    final reference = FirebaseFirestore.instance
        .collection(Constant.LOBBY_COLLECTION)
        .doc(state.widget.lobby.docId);
    listener = reference.snapshots().listen((event) {
      var document = event.data() as Map<String, dynamic>;
      var l = Lobby.fromFirestoreDoc(doc: document, docId: event.id);
      if (l != null) state.widget.lobby.setProperties(l);
      if (state.widget.lobby.state == 0) {
        state.playerAnswers.clear();
        for (int i = 0; i < state.widget.lobby.players.length; i++) {
          state.playerAnswers.add(false);
        }
        for (int i = 0; i < state.widget.lobby.players.length; i++) {
          for (int j = 0; j < state.widget.lobby.answers.length; j++) {
            if (state.widget.lobby.players[i]['id'].toString().compareTo(
                    state.widget.lobby.answers[j]['id'].toString()) ==
                0) {
              state.playerAnswers[i] = true;
            }
          }
        }
      }
      if (state.widget.lobby.state == 1) {
        lastQuestionFirstName = state.widget.lobby.questions[0]['answer'];
        lastQuestionFirstRating = double.parse(
            state.widget.lobby.questions[0]['fields'][0]['data'][0]['data']);
        lastQuestionSecondName = state.widget.lobby.questions[1]['answer'];
        lastQuestionSecondRating = double.parse(
            state.widget.lobby.questions[1]['fields'][0]['data'][0]['data']);
        storedAnswers = [...state.widget.lobby.answers];
      }
      if (state.widget.lobby.state == 2) {
        int storedAnswer = answer;
        if (answer >= 0 && answer <= 2) {
          if (lastQuestionFirstRating > lastQuestionSecondRating) {
            correctAnswer = 0;
          } else if (lastQuestionFirstRating < lastQuestionSecondRating) {
            correctAnswer = 2;
          } else {
            correctAnswer = 1;
          }
          showDialog(
            context: state.context,
            builder: (BuildContext context) {
              return _popupDialog(
                context,
                storedAnswer == correctAnswer,
                true,
                lastQuestionFirstName,
                lastQuestionFirstRating,
                lastQuestionSecondName,
                lastQuestionSecondRating,
                storedAnswers,
              );
            },
          );
        }
        answer = -1;
      }
      if (state.widget.player.id.compareTo(state.widget.lobby.id) == 0 &&
          state.widget.lobby.state == 0 &&
          state.widget.lobby.answers.length ==
              state.widget.lobby.players.length) {
        Map<String, dynamic> updateInfo = {};
        updateInfo[Lobby.PLAYER_INDEX] = state.widget.lobby.playerIndex + 1;
        updateInfo[Lobby.STATE] = 1;

        FirestoreController.updateLobby(
            docId: state.widget.lobby.docId!, updateInfo: updateInfo);
      } else if (state.widget.player.id.compareTo(state.widget.lobby.id) == 0 &&
          state.widget.lobby.state == 1 &&
          state.widget.lobby.answers.length ==
              state.widget.lobby.players.length) {
        Map<String, dynamic> updateInfo = {};
        updateInfo[Lobby.STATE] = 2;

        FirestoreController.updateLobby(
            docId: state.widget.lobby.docId!, updateInfo: updateInfo);
      } else if (state.widget.player.id.compareTo(state.widget.lobby.id) == 0 &&
          state.widget.lobby.state == 2) {
        for (var answer in state.widget.lobby.answers) {
          if (answer['answer']
                  .toString()
                  .toLowerCase()
                  .compareTo(correctAnswer.toString()) ==
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
        if (state.widget.lobby.questions.isEmpty ||
            state.widget.lobby.questions.length < 2) {
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

  void resetListener(BuildContext context) {
    listener.cancel();
    listenerFunction();
    Navigator.of(context).pop();
  }
}
