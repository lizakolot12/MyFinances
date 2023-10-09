import 'package:flutter/material.dart';
import 'package:my_study/data/data.dart';
import 'package:my_study/items.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  final List<Transaction> list = TransactionRepository().getAll();
  int selectedIndex = 0;
  bool stretch = true;

  void addNew() {
    setState(() {});
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void remove(int index) {
    setState(() {
      list.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            tooltip: 'Add new',
            onPressed: addNew,
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Поточні',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Звіти',
              ),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: onItemTapped,
          ),
          appBar: AppBar(
            title: const Text('Мої витрати'),
          ),
          body: selectedIndex == 0
              ? mySliver()
              : const Center(
                  child: Text('Вміст вкладки 2'),
                ),

        ));
  }

  Widget mySliver(){
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          stretch: stretch,
          onStretchTrigger: () async {
            // Triggers when stretching
          },
          // [stretchTriggerOffset] describes the amount of overscroll that must occur
          // to trigger [onStretchTrigger]
          //
          // Setting [stretchTriggerOffset] to a value of 300.0 will trigger
          // [onStretchTrigger] when the user has overscrolled by 300.0 pixels.
          stretchTriggerOffset: 300.0,
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Що було куплено нещодавно',
                style: TextStyle(shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  /*    Shadow(
                          offset: Offset(10.0, 10.0),
                          blurRadius: 8.0,
                          color: Color.fromARGB(125, 0, 0, 255),
                        )*/
                ])),
            background:
            Image.asset("assets/images/cake.png", fit: BoxFit.cover),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return TransactionItem(
                transaction: list[index],
                key: UniqueKey(),
              );
            },
            childCount: list.length,
          ),
        ),
      ],
    );
  }

  Widget buildList() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
            key: Key(list[index].name),
            onDismissed: (direction) {
              remove(index);
            },
            child: TransactionItem(
              transaction: list[index],
              key: UniqueKey(),
            ));
      },
    );
  }

  Widget createBody() {
    return Column(
      children: <Widget>[const Text('Some UI'), Expanded(child: buildList())],
    );
  }
}
