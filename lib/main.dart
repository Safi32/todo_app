import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_list.dart';
import 'package:todo_app/screens/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const TodoListPage(),
      routes: {
        TodoListPage.routeName: (contex) => const TodoListPage(),
        AddList.routeName: (context) => const AddList(),
      },
    );
  }
}
