import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/screens/add_list.dart';

class TodoListPage extends StatefulWidget {
  static const routeName = "TodoList";
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isTrue = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
        centerTitle: true,
      ),
      body: Visibility(
        visible: isTrue,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchData,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                "No Todo Items",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            child: ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return Card(
                    child: ListTile(
                      // title: Text(item.toString()),
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text(item['title']),
                      subtitle: Text(item['description']),
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'Edit') {
                            navigateToEditPage(item);
                          } else if (value == "Delete") {
                            // Delte page
                            deletebyId(id);
                          }
                        },
                        icon: const Icon(
                          Icons.more_horiz,
                        ),
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: "Edit",
                              child: Text("Edit"),
                            ),
                            const PopupMenuItem(
                              value: "Delete",
                              child: Text("Delte"),
                            ),
                          ];
                        },
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, AddList.routeName);
          setState(() {
            isTrue = true;
          });
          fetchData();
        },
        label: const Text("Add Page"),
      ),
    );
  }

  Future<void> fetchData() async {
    const url = "https://api.nstack.in/v1/todos?page=1&limit=20";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
        isTrue = false;
      });
    } else {
      setState(() {
        isTrue = true;
      });
    }
  }

  Future<void> deletebyId(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {}
  }

  void navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddList(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isTrue = true;
    });
    fetchData();
  }
}
