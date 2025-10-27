// Halaman untuk menambahkan tugas (To-Do) baru
// Menggunakan form sederhana dengan validasi input
// Data disimpan ke Hive melalui TodoProvider

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  // Nama route untuk navigasi bernama
  static const routeName = '/add-todo';

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  // Key untuk form, digunakan agar bisa memvalidasi input
  final _formKey = GlobalKey<FormState>();
  //Controller untuk mengambil teks dari input field
  final _controller = TextEditingController();

  @override
  void dispose() {
    // selalu dispose controller agar tidak ada memory leak
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      // Mengambil instance TodoProvider dari context
      await context.read<TodoProvider>().add(_controller.text.trim());
      // mounted: memastikan widget masih aktif sebelum Navigator.pop
      if (mounted) Navigator.pop(context);
    }
  }

  // Tampilan utama halaman tambah to-do
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add To-Do')),
      // Body: form input
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              // Input field untuk judul to-do
              TextFormField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g. Buy milk',
                ),
                // Validasi: tidak boleh kosong
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Title can’t be empty' : null,
                onFieldSubmitted: (_) => _save(), // tekan Enter maka akan tersimpan
              ),
              const SizedBox(height: 24),

              // Tombol simpan dengan ikon
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
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
