import 'dart:async';

class MockAPI {
  final List<Task> _list = [
    Task(
      id: 1,
      title: "Вивчити Flutter",
      isProgress: false,
    ),
    Task(
      id: 2,
      title: "Зробити ДЗ",
      isProgress: false,
    ),
    Task(
      id: 3,
      title: "Прочитати книгу",
      isProgress: false,
    ),
  ];

  Future<List<Task>> getTasks() async {
    print("1");
    await Future.delayed(const Duration(seconds: 1));
    print("2");
    return _list;
  }

  Future<void> removeTask(int index) async {
    _list[index].isProgress = true;
    print("3");
    await Future.delayed(const Duration(seconds: 1));
    print("4");
    _list.removeAt(index);
    print("5");
  }

  Future<void> addTask(String title) async {
    await Future.delayed(const Duration(seconds: 1));
    _list.add(Task(id: 1, title: title, isProgress: false));
  }
}

class MockRepository {
  MockRepository(this.api);

  late MockAPI api;

  Future<List<Task>> fetchTasks() async {
    var tasks = await api.getTasks();
    _controller.add(tasks.length);
    return tasks;
  }

  Future<void> removeTask(int id) async => api.removeTask(id);

  Future<void> addTask(String name) async => api.addTask(name);

  final _controller = StreamController<int>();

  Stream<int> get count => _controller.stream;
}

class Task {
  final int id;
  final String title;
  bool isProgress;

  Task({
    required this.id,
    required this.title,
    required this.isProgress,
  });
}
