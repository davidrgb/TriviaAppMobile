import 'package:flutter/material.dart';
import 'package:trivia_app/model/category.dart';
import 'package:trivia_app/viewscreen/create_screen.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/categoryScreen';

  const CategoryScreen(List<Category> this.categories, {Key? key})
      : super(key: key);

  final List<Category> categories;

  @override
  State<StatefulWidget> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late _Controller controller;

  late CategoryScreen screen;

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
            for (int i = 0; i < widget.categories.length; i++)
              ElevatedButton(
                onPressed: () => controller.create_lobby(widget.categories[i]),
                child: Text(widget.categories[i].name),
              ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  late _CategoryScreenState state;
  _Controller(this.state);

  void create_lobby(Category category) async {
    await Navigator.pushNamed(
      state.context,
      CreateScreen.routeName,
      arguments: category,
    );
  }
}
