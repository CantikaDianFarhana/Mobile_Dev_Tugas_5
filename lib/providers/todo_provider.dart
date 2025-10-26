import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/todo.dart';

class TodoProvider extends ChangeNotifier {
  static const String boxName = 'todos_box';
  Box<Todo>? _box;

  bool get isReady => _box != null && _box!.isOpen;

  /// Sorting: terbaru di depan (createdAt desc)
  List<Todo> get items {
    final list = [...(_box?.values ?? const Iterable<Todo>.empty())];
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> init() async {
    _box ??= await Hive.openBox<Todo>(boxName);
    notifyListeners();
  }

  Future<void> add(String title) async {
    if (!isReady) return;
    await _box!.add(Todo(title: title));
    notifyListeners();
  }

  Future<void> toggle(Todo todo) async {
    todo.isDone = !todo.isDone;
    await todo.save();
    notifyListeners();
  }

  Future<void> rename(Todo todo, String newTitle) async {
    todo.title = newTitle.trim();
    await todo.save();
    notifyListeners();
  }

  Future<void> remove(Todo todo) async {
    await todo.delete();
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _box?.clear();
    notifyListeners();
  }
}
