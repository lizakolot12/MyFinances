import 'package:flutter/material.dart';
import 'package:my_study/data/data.dart';
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
      title: 'Мої витрати',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Мої витрати'),
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
  final List<Transaction> _list = TransactionRepository().getAll();

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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: _changeView,
              tooltip: 'Add new',
              child: const Icon(Icons.ac_unit),
            ),
            appBar: AppBar(
              title: Text('Мої витрати'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Поточні'),
                  Tab(text: 'Звіт'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Center(
                  child: body(context),
                ),
                const Center(
                  child: Text('Вміст вкладки 2'),
                ),
              ],
            )));
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
            child: TransactionItem(
              transaction: _list[index],
              key: UniqueKey(),
            ));
      },
    );
  }

  Widget body(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Deliver features faster'),
        Text('Craft beautiful UIs'),
        Expanded(
            // Визначте висоту списку за вашими потребами
            child: buildList(context))
      ],
    );
  }
}
