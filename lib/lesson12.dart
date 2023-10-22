import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_study/util12.dart';

class Lesson12 extends StatelessWidget {
  const Lesson12({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Future vs Stream',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lesson12'),
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
  late MockRepository repository;

  @override
  void initState() {
    repository = MockRepository(MockAPI());
    super.initState();
  }

  void remove(int index) {
    setState(() {
      repository.removeTask(index);
    });
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
            Spacer(),
            StreamBuilder<int>(
                stream: repository.count,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    return Text('Total: ${snapshot.data}');
                  } else {
                    return const Text("sdj");
                  }
                },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: repository.fetchTasks(),
        builder: (_, AsyncSnapshot<List<Task>> snapshot) {
          if (snapshot.hasData) {
            return Stack(children: [
              ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) => ListTile(
                  title: Row(
                    children: [
                      Text(
                        snapshot.data?[index].title ?? '',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      IconButton(
                          disabledColor: Colors.black12,
                          icon: const Icon(
                            Icons.delete,
                          ),
                          onPressed: snapshot.data?[index].isProgress ?? false
                              ? null
                              : () => remove(index)
                          /*   onPressed:  snapshot.data?[index].isProgress??  () {
                          remove(index);
                        }: null,*/
                          ),
                    ],
                  ),
                ),
              ),
              if (snapshot.connectionState == ConnectionState.waiting)
                progress()
            ]);
          } else {
            return progress();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          textFieldController = TextEditingController();
          displayTextInputDialog(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget progress() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  TextEditingController textFieldController = TextEditingController();
  String? valueText;

  Future<void> displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Input new task'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                print(value);
                valueText = value;
              });
            },
            controller: textFieldController,
            decoration: const InputDecoration(hintText: "Title"),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('CANCEL'),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
            MaterialButton(
              color: Colors.green,
              textColor: Colors.white,
              child: const Text('OK'),
              onPressed: () {
                setState(
                  () {
                    if (valueText != null) {
                      repository.addTask(valueText ?? "");
                    }

                    Navigator.pop(context);
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
