import 'package:flutter/material.dart';
import 'package:my_study/items.dart';
import 'data/recipe.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'My recipes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _grid = false;
  final List<Recipe> _list = RecipeRepository().getAll();

  void _changeView() {
    setState(() {
      _grid = !_grid;
    });
  }

  void _remove(int index) {
    //setState(() {
    _list.removeAt(index);
    //});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _grid == true ? buildGrid(context) : buildList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeView,
        tooltip: 'Change view',
        child: const Icon(Icons.ac_unit),
      ),
    );
  }

  Widget buildGrid(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16),
        itemCount: _list.length,
        itemBuilder: (BuildContext ctx, index) {
          return FullItem(_list[index], key: UniqueKey());
        });
  }

  Widget buildList(BuildContext context) {
    return ListView.builder(
      itemCount: _list.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
            key: Key(_list[index].name),
            onDismissed: (direction) {
              _remove(index);
            },
            child: SimpleItem(
              recipe: _list[index],
              key: UniqueKey(),
            ));
      },
    );
  }
}
