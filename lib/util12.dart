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
    await Future.delayed(const Duration(seconds: 1));
    return _list;
  }

  Future<void> removeTask(int index) async {
    _list[index].isProgress = true;
    await Future.delayed(const Duration(seconds: 1));
    _list.removeAt(index);
  }

  Future<void> addTask(String title) async {
    await Future.delayed(const Duration(seconds: 1));
    _list.add(Task(id: 1, title: title, isProgress: false));
  }
}

class MockRepository {
  late MockAPI api;

  MockRepository(this.api);

  Future<List<Task>> fetchTasks() async {
    var tasks = await api.getTasks();
    _controller.sink.add(tasks.length);
    return tasks;
  }

  Future<void> removeTask(int id) async => api.removeTask(id);

  Future<void> addTask(String name) async => api.addTask(name);

  final _controller = StreamController<int>.broadcast();

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
