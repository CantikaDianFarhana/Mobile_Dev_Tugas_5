import 'package:hive/hive.dart';

class Todo extends HiveObject {
  String title;
  bool isDone;
  DateTime createdAt;

  Todo({
    required this.title,
    this.isDone = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  final int typeId = 1; // typeId harus unik

  @override
  Todo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Todo(
      title: fields[0] as String,
      isDone: fields[1] as bool,
      createdAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer
      ..writeByte(3) // jumlah field
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isDone)
      ..writeByte(2)
      ..write(obj.createdAt);
  }
}
