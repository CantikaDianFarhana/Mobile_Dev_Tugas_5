// Widget reusable untuk menampilkan satu item tugas (To-Do).
// Berisi judul, status, serta tombol edit dan delete.

import 'package:flutter/material.dart';

import '../models/todo.dart';

// Widget stateless karena semua data dikontrol dari luar (melalui provider)
class TodoCard extends StatelessWidget {
  final Todo todo; // Objek Todo yang akan ditampilkan
  final VoidCallback onToggle; // Callback saat status diubah (done/pending)
  final VoidCallback onDelete; // Callback untuk hapus todo
  final VoidCallback? onEdit;  // Callback opsional untuk mengedit todo

  const TodoCard({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      // Ganti warna kartu berdasarkan status todo
      color: todo.isDone ? Colors.green : Colors.orange,
      elevation: 1.5,
      borderRadius: BorderRadius.circular(16),
      // InkWell dipakai agar kartu bisa ditekan dengan efek ripple
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian tombol edit dan hapus di pojok kanan atas
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Edit',
                      onPressed: onEdit,
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Judul tugas
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  todo.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    // Garis coret untuk status selesai
                    decoration: todo.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Checkbox status + label (Done / Pending)
              Row(
                children: [
                  Checkbox(
                    value: todo.isDone,
                    onChanged: (_) => onToggle(),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    todo.isDone ? 'Done' : 'Pending',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
