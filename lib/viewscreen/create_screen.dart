import 'package:flutter/material.dart';
import 'package:trivia_app/controller/FirestoreController.dart';
import 'package:trivia_app/model/category.dart';
import 'package:trivia_app/model/constant.dart';
import 'package:trivia_app/model/field.dart';

import 'dart:math';

import 'package:trivia_app/model/lobby.dart';
import 'package:trivia_app/model/question.dart';
import 'package:trivia_app/viewscreen/lobby_screen.dart';

class CreateScreen extends StatefulWidget {
  static const routeName = '/createScreen';

  const CreateScreen(this.category, {Key? key}) : super(key: key);

  final Category category;

  @override
  State<StatefulWidget> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  late _Controller controller;
  GlobalKey<FormState> lobbyNameKey = GlobalKey<FormState>();

  late CreateScreen screen;

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    controller = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name + ' Lobby'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: lobbyNameKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: 'Your Name'),
                keyboardType: TextInputType.name,
                autocorrect: false,
                validator: controller.validatePlayerName,
                onSaved: controller.savePlayerName,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Lobby Name'),
                keyboardType: TextInputType.name,
                autocorrect: false,
                validator: controller.validateLobbyName,
                onSaved: controller.saveLobbyName,
              ),
              ElevatedButton(
                onPressed: controller.create_lobby,
                child: Text('Create Lobby'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  late _CreateScreenState state;
  _Controller(this.state);

  String? playerName;
  String? lobbyName;

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

  String? validateLobbyName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lobby name required.';
    } else if (value.length > 20) {
      return 'Lobby name is too long';
    } else {
      return null;
    }
  }

  void saveLobbyName(String? value) {
    if (value != null) lobbyName = value;
  }

  void create_lobby() async {
    FormState? currentState = state.lobbyNameKey.currentState;
    if (currentState == null || !currentState.validate()) return;

    currentState.save();

    try {
      var rng = new Random();
      String playerId =
          playerName.toString() + (rng.nextInt(999) + 1).toString();

      List<Question> questions =
          await FirestoreController.getQuestionsFromCategory(
              state.widget.category.name);
      List<dynamic> selectedQuestions = [];
      for (int i = 0; i < 1; i++) {
        int index = rng.nextInt(questions.length);
        Question selectedQuestion = questions[index];
        List<Field> fields = [];
        for (var field in selectedQuestion.fields) {
          fields
              .add(await FirestoreController.getFieldFromDocId(field['data']));
        }

        selectedQuestion.fields.clear();

        List<dynamic> selectedFields = [];
        for (var field in fields) {
          while (field.data.length > 5) {
            int index = rng.nextInt(field.data.length);
            field.data.removeAt(index);
          }
          field.data.shuffle();
          selectedFields.add({
            "name": field.name,
            "data": field.data,
          });
        }

        selectedQuestions.add({
          "answer": selectedQuestion.answer,
          "category": selectedQuestion.category,
          "info": selectedQuestion.info,
          "fields": selectedFields,
        });
      }

      List<dynamic> players = [
        {
          "name": playerName,
          "id": playerId,
          "score": 0,
        }
      ];

      Lobby lobby = Lobby(
        category: state.widget.category.name,
        host: playerName!,
        id: playerId,
        name: lobbyName!,
        open: true,
        players: players,
        questions: selectedQuestions,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      lobby.docId = await FirestoreController.createLobby(lobby);

      await Navigator.pushNamed(
        state.context,
        LobbyScreen.routeName,
        arguments: lobby,
      );
    } catch (e) {
      print('======== Error creating lobby: $e');
    }
  }
}
