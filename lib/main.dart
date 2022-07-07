import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trivia_app/firebase_options.dart';
import 'package:trivia_app/model/category.dart';
import 'package:trivia_app/model/constant.dart';
import 'package:trivia_app/model/lobby.dart';
import 'package:trivia_app/viewscreen/GameScreen.dart';
import 'package:trivia_app/viewscreen/category_screen.dart';
import 'package:trivia_app/viewscreen/create_screen.dart';
import 'package:trivia_app/viewscreen/home_screen.dart';
import 'package:trivia_app/viewscreen/join_screen.dart';
import 'package:trivia_app/viewscreen/lobby_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(TriviaApp());
}

class TriviaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trivia App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            textStyle: TextStyle(fontSize: 24.0, color: Colors.white),
          ),
        ),
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (BuildContext context) => const HomeScreen(),
        CategoryScreen.routeName: (BuildContext context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          return CategoryScreen(args as List<Category>);
        },
        CreateScreen.routeName: (BuildContext context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          return CreateScreen(args as Category);
        },
        JoinScreen.routeName: (BuildContext context) => const JoinScreen(),
        LobbyScreen.routeName: (BuildContext context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          var arguments = args as Map;
          var lobby = arguments[ARGS.LOBBY];
          var player = arguments[ARGS.PLAYER];
          return LobbyScreen(lobby, player);
        },
        GameScreen.routeName: (BuildContext context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          var arguments = args as Map;
          var lobby = arguments[ARGS.LOBBY];
          var player = arguments[ARGS.PLAYER];
          return GameScreen(lobby, player);
        },
      },
    );
  }
}
