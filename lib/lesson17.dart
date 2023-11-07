import 'dart:async';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:my_study/util17.dart';

class Lesson17 extends StatelessWidget {
  const Lesson17({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DIO',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lesson17'),
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
  late PostRepository repository;

  @override
  void initState() {
    super.initState();
    repository = PostRepository(DioClient());
  }

  void remove(int userId) {
    repository.removePost(userId);
    setState(() {});
  }

  void addTask(String title) {
    repository.addPost(title);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            Text(
              widget.title,
            ),
            const Spacer(),
            StreamBuilder<int>(
              stream: repository.count,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.hasData) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: const Offset(0.0, 0.0),
                          ).animate(animation),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      'Total: ${snapshot.data}',
                      key: ValueKey<int>(snapshot.data ?? 0),
                    ),
                  );
                } else {
                  return const Text("");
                }
              },
            ),
          ],
        ),
      ),
      body: LiquidPullToRefresh(
          onRefresh: () {
            return Future(() {
              setState(() {});
            });
          },
          child: FutureBuilder(
            future: repository.fetchPosts(),
            builder: (_, AsyncSnapshot<ListState> snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: [
                    buildListView(snapshot),
                    if (snapshot.data?.error != null) buildErrorView(snapshot),
                    if (snapshot.connectionState == ConnectionState.waiting)
                      progress()
                  ],
                );
              } else {
                return progress();
              }
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          displayTextInputDialog(context);
        },
        tooltip: 'New post',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildErrorView(AsyncSnapshot<ListState> snapshot) {
    print("error view");
    return Center(
        child: Text(
      snapshot.data?.error ?? "",
      style: Theme.of(context).textTheme.titleMedium,
    ));
  }

  ListView buildListView(AsyncSnapshot<ListState> snapshot) {
    print("build list");
    return ListView.builder(
      itemCount: snapshot.data?.list.length ?? 0,
      itemBuilder: (context, index) => ListTile(
        title: Text(
          snapshot.data?.list[index].title ?? '',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: IconButton(
            disabledColor: Colors.black12,
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: snapshot.data?.list[index].isProgress ?? false
                ? null
                : () => remove(snapshot.data?.list[index].id ?? 0)),
      ),
    );
  }

  Widget progress() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<void> displayTextInputDialog(BuildContext context) async {
    String? valueText;
    TextEditingController textFieldController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Input new task'),
          content: TextField(
            onChanged: (value) {
              setState(
                () {
                  valueText = value;
                },
              );
            },
            controller: textFieldController,
            decoration: const InputDecoration(hintText: "Title"),
          ),
          actions: <Widget>[
            MaterialButton(
              child: const Text('CANCEL'),
              onPressed: () {
                setState(
                  () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
            MaterialButton(
              child: const Text('OK'),
              onPressed: () {
                setState(
                  () {
                    if (valueText != null) {
                      addTask(valueText ?? "");
                      Navigator.pop(context);
                    }
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
