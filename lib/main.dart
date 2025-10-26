import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/screens/add_todo_screen.dart';
import 'package:todo/screens/edit_todo_screen.dart';
import 'package:todo/screens/home_screen.dart';

import 'models/todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(TodoAdapter());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoProvider()..init(),
      child: MaterialApp(
        title: 'To-Do App',
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF246BFD),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: HomeScreen.routeName,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case HomeScreen.routeName:
              return MaterialPageRoute(builder: (_) => const HomeScreen());
            case AddTodoScreen.routeName:
              return MaterialPageRoute(builder: (_) => const AddTodoScreen());
            case EditTodoScreen.routeName:
              final selectedTodo = settings.arguments as Todo;
              return MaterialPageRoute(builder: (_) => EditTodoScreen(selectedTodo: selectedTodo));
            default:
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(child: Text('Screen not found')),
                ),
              );
          }
        },
      ),
    );
  }
}
