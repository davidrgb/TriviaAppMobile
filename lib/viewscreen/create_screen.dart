import 'package:flutter/material.dart';
import 'package:trivia_app/model/category.dart';

class CreateScreen extends StatefulWidget {
  static const routeName = '/createScreen';

  const CreateScreen(Category this.category, {Key? key}) : super(key: key);

  final Category category;

  @override
  State<StatefulWidget> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  late _Controller controller;

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
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(widget.category.name),
            ElevatedButton(
              onPressed: controller.create_lobby,
              child: Text('Create Lobby'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  late _CreateScreenState state;
  _Controller(this.state);

  void create_lobby() async {}
}
