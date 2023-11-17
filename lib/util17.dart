import 'dart:async';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 3),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  DioClient() {
    print('default constructor');
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: false,
        responseBody: false,
        responseHeader: false,
        compact: false,
      ),
    );
  }

  Future<List<Post>> getPosts() async {
    Response response = await _dio.get('/posts');
    List<Post> list = (response.data as List)
        .map(
          (x) => Post.fromJson(x),
        )
        .toList();
    return list;
  }

  Future<void> removePost(int id) async {
    await _dio.delete('/posts/$id');
  }

  Future<void> addPost(String title) async {
    Post post = Post(title: title, id: 9);
    await _dio.post(
      '/posts',
      data: post.toJson(),
    );
  }
}

class PostRepository {
  late DioClient api;
  List<Post> _list = List.empty();

  PostRepository(this.api);

  Future<ListState> fetchPosts() async {
    try {
      _list = await api.getPosts();
      _controller.sink.add(_list.length);
      return ListState(list: _list, error: null);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          return ListState(
              list: List.empty(), error: "Проблеми з мережею інтернет");
        } else {
          return ListState(
              list: List.empty(),
              error: "Проблеми з сервером. Зверніться до адміністратора");
        }
      }
      return ListState(list: List.empty(), error: e.toString());
    }
  }

  Future<void> removePost(int id) async {
    api.removePost(id);
    _list.removeWhere((element) => element.id == id);
  }

  Future<void> addPost(String name) async {
    api.addPost(name);
  }

  final _controller = StreamController<int>.broadcast();

  Stream<int> get count => _controller.stream;
}

@JsonSerializable()
class Post {
  final int id;
  final String title;
  bool isProgress = false;

  Post({
    required this.id,
    required this.title,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}

class ListState {
  List<Post> list;
  String? error;

  ListState({
    required this.list,
    required this.error,
  });
}
