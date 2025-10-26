import 'package:flutter/material.dart';
import 'package:todo/screens/add_todo_screen.dart';

class EmptyViews extends StatelessWidget {
  const EmptyViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Create your first to-do'),
        onPressed: () => Navigator.pushNamed(context, AddTodoScreen.routeName),
      ),
    );
  }
}
