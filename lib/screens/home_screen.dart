import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/screens/add_todo_screen.dart';
import 'package:todo/screens/edit_todo_screen.dart';
import 'package:todo/views/empty_views.dart';

import '../providers/todo_provider.dart';
import '../widgets/todo_card.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home'; // digunakan untuk navigasi bernama

  const HomeScreen({super.key});

  // Fungsi dialog konfirmasi untuk menghapus semua to-do.
  // Menampilkan AlertDialog dengan 2 tombol:
  // - Cancel: batal
  // - Delete all: hapus semua
  Future<bool> _confirmClearAll(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete all to-dos?'),
        content: const Text('This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Delete all',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Widget utama halaman home
  // Pakai Consumer<TodoProvider> agar UI otomatis
  // diperbarui setiap kali data berubah
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (_, provider, __) {
        final todos = provider.items; // ambil daftar semua to-do dari provider

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('To-Do`s App'),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            actions: [
              // Tombol hapus semua todo
              IconButton(
                icon: const Icon(
                  Icons.delete_sweep,
                  color: Colors.red,
                ),
                tooltip: 'Clear all',
                onPressed: todos.isEmpty
                    ? null // tombol nonaktif kalau tidak ada data
                    : () async {
                        final ok = await _confirmClearAll(context);
                        if (ok) {
                          await provider.clearAll(); // hapus semua dat
                        }
                      },
              ),
            ],
          ),

          // Body utama halaman:
          // 1. Jika Hive belum siap: menampilkan loading
          // 2. Jika belum ada data: menampilkan tampilan kosong
          // 3. Jika ada data: menampilkan ListView berisi TodoCard
          body: !provider.isReady
              ? const Center(child: CircularProgressIndicator())
              : todos.isEmpty
                  ? const EmptyViews()
                  : Padding(
                      padding: const EdgeInsets.all(12),
                      child: ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (_, i) {
                          final todo = todos[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TodoCard(
                              todo: todo,
                              onToggle: () => provider.toggle(todo),
                              onDelete: () => provider.remove(todo),
                              onEdit: () => Navigator.pushNamed(
                                context,
                                EditTodoScreen.routeName,
                                arguments: todo,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

          // Floating Action Button: Navigasi ke halaman tambah todo
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, AddTodoScreen.routeName),
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
        );
      },
    );
  }
}
