// Halaman untuk mengubah (rename) dan menghapus to-do yang sudah ada.
// Data yang diedit akan langsung disimpan kembali ke Hive melalui TodoProvider

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/todo.dart';

import '../providers/todo_provider.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo selectedTodo; // To-do yang dipilih dari halaman sebelumnya (HomeScreen)

  const EditTodoScreen({
    super.key,
    required this.selectedTodo,
  });

  // Route name agar bisa diakses via Navigator.pushNamed
  static const routeName = '/edit-todo';

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final _formKey = GlobalKey<FormState>(); // Key untuk Form, digunakan untuk validasi input
  late final TextEditingController _controller; // Controller untuk field judul to-do

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.selectedTodo.title); // Isi TextField awalnya dengan judul to-do yang dipilih
  }

  @override
  void dispose() {
    // Selalu dispose controller untuk cegah memory leak
    _controller.dispose();
    super.dispose();
  }

  // Simpan perubahan judul to-do
  // - Validasi: tidak boleh kosong
  // - Panggil provider.rename() untuk update data di Hive
  // - Kembali ke halaman sebelumnya setelah berhasil
  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      await context.read<TodoProvider>().rename(widget.selectedTodo, _controller.text.trim());
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDone = widget.selectedTodo.isDone; // status selesai / belum
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit To-Do'),
        // Tombol hapus item ini
        actions: [
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // Hapus todo saat ini
              await context.read<TodoProvider>().remove(widget.selectedTodo);
              // Tutup halaman edit setelah dihapus
              if (mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      // Body berisi form edit dan indikator status to-do
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Jika ingin toggle status di halaman edit, aktifkan onChanged di bawah
              Row(
                children: [
                  Checkbox(
                    value: isDone,
                    onChanged: null, // fokus rename; ubah ke (_) => setState(() { ... })
                  ),
                  Text(isDone ? 'Done' : 'Pending'),
                ],
              ),
              // Input untuk mengubah judul to-do
              TextFormField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Update title',
                ),
                // Validasi: judul tidak boleh kosong
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Title can’t be empty' : null,
                onFieldSubmitted: (_) => _save(), // Tekan enter maka akan tersimpan
              ),
              const SizedBox(height: 24),
              // Tombol untuk menyimpan perubahan judul
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save changes'),
                  onPressed: _save,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
