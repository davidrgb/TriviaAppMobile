import 'package:flutter/material.dart';
import 'package:trivia_app/controller/FirestoreController.dart';
import 'package:trivia_app/model/category.dart';
import 'package:trivia_app/viewscreen/category_screen.dart';
import 'package:trivia_app/viewscreen/join_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(50),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: controller.createLobby,
                child: Text('Create Lobby'),
              ),
              ElevatedButton(
                onPressed: controller.joinLobby,
                child: Text('Join Lobby'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  late _HomeScreenState state;
  _Controller(this.state);

  void createLobby() async {
    List<Category> categories = await FirestoreController.getCategories();
    await Navigator.pushNamed(
      state.context,
      CategoryScreen.routeName,
      arguments: categories,
    );
  }

  void joinLobby() async {
    await Navigator.pushNamed(
      state.context,
      JoinScreen.routeName,
    );
  }
}
