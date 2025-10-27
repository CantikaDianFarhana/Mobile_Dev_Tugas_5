// Model utama untuk data To-Do.
// File ini berisi class To-do yang mewakili 1 tugas
// dan adanya adaptor Hive supaya data bisa disimpan secara lokal.

import 'package:hive/hive.dart';

// Setiap class model yang akan disimpan di Hive
// harus extend dari HiveObject agar punya akses ke fungsi save(), delete(), dll
class Todo extends HiveObject {
  String title;
  bool isDone; // Status tugas (selesai / belum)
  DateTime createdAt;  // Waktu tugas dibuat

  // Konstruktor
  Todo({
    required this.title,
    this.isDone = false, // default belum selesai
    DateTime? createdAt, // kalau tidak diisi, otomatis tanggal saat ini
  }) : createdAt = createdAt ?? DateTime.now();
}

// TypeAdapter diperlukan agar Hive tahu
// cara membaca & menulis objek To-do ke dalam box
class TodoAdapter extends TypeAdapter<Todo> {
  @override
  // Jika kamu menambah model lain (misal UserAdapter), gunakan typeId berbeda
  final int typeId = 1; // typeId harus unik

  // Fungsi untuk membaca data dari Hive (deserialization)
  @override
  Todo read(BinaryReader reader) {
    final numOfFields = reader.readByte(); // jumlah field
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      // setiap field dibaca berdasarkan index dan tipe datanya
      fields[reader.readByte()] = reader.read();
    }
    return Todo(
      title: fields[0] as String,
      isDone: fields[1] as bool,
      createdAt: fields[2] as DateTime,
    );
  }

  // Fungsi untuk menulis data ke Hive (serialization)
  @override
  void write(BinaryWriter writer, Todo obj) {
    writer
      ..writeByte(3) // jumlah field yang disimpan
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isDone)
      ..writeByte(2)
      ..write(obj.createdAt);
  }
}
