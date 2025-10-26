import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/todo.dart';

import '../providers/todo_provider.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo selectedTodo;

  const EditTodoScreen({
    super.key,
    required this.selectedTodo,
  });

  static const routeName = '/edit-todo';

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.selectedTodo.title);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      await context.read<TodoProvider>().rename(widget.selectedTodo, _controller.text.trim());
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDone = widget.selectedTodo.isDone;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit To-Do'),
        actions: [
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await context.read<TodoProvider>().remove(widget.selectedTodo);
              if (mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
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
              TextFormField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Update title',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Title can’t be empty' : null,
                onFieldSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 24),
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
