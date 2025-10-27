// Provider utama untuk mengelola data To-Do dan sinkronisasi
// antara penyimpanan lokal (Hive) dan UI

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

// Import model To-do agar Provider dapat menyimpan dan memanggil objek To-do
import '../models/todo.dart';

class TodoProvider extends ChangeNotifier {
  // Nama box Hive untuk menyimpan data tugas
  static const String boxName = 'todos_box';
  Box<Todo>? _box;

  bool get isReady => _box != null && _box!.isOpen;

  // Getter untuk mengambil semua item Todo
  // Sorting: terbaru di depan (createdAt desc)
  List<Todo> get items {
    final list = [...(_box?.values ?? const Iterable<Todo>.empty())];
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  // Fungsi untuk membuka box Hive
  // Harus dipanggil di awal (biasanya di main.dart atau initState)
  Future<void> init() async {
    _box ??= await Hive.openBox<Todo>(boxName);
    notifyListeners(); // kasih tahu UI bahwa data siap digunakan
  }

  // CREATE: Menambah To-do baru ke box Hive
  Future<void> add(String title) async {
    if (!isReady) return; // pastikan box sudah siap
    await _box!.add(Todo(title: title));
    notifyListeners(); // perbarui tampilan
  }

  // UPDATE (toggle status)
  // Mengubah status selesai / belum selesai pada suatu To-do
  Future<void> toggle(Todo todo) async {
    todo.isDone = !todo.isDone;
    await todo.save(); // simpan perubahan ke Hive
    notifyListeners(); // beri tahu UI
  }

  // UPDATE (rename)
  // Ubah judul To-do dan simpan ke Hive
  Future<void> rename(Todo todo, String newTitle) async {
    todo.title = newTitle.trim();
    await todo.save();
    notifyListeners();
  }

  // DELETE: Menghapus satu To-do dari box
  Future<void> remove(Todo todo) async {
    await todo.delete();
    notifyListeners();
  }

  // CLEAR: Menghapus semua To-do dari box
  Future<void> clearAll() async {
    await _box?.clear();
    notifyListeners();
  }
}
