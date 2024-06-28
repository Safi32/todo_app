import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddList extends StatefulWidget {
  static const routeName = "addList";
  final Map? todo;
  const AddList({super.key, this.todo});

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "Edit Todo" : "Add Todo",
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: Text(isEdit ? "Update" : "Submit"),
          ),
        ],
      ),
    );
  }

  void updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print("You cannot call updated withoud todo data");
      return;
    }
    final id = todo['_id'];

    final title = titleController.text;
    final description = titleController.text;
    final body = {
      "title": title,
      "description": description,
      "isCompleted": false,
    };
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      showSnackBarMessage("Update Sucessful");
    } else {
      showSnackBarErrorMessage("Error in update");
    }
  }

  void submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "isCompleted": false,
    };
    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: json.encode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 201) {
      titleController.text = ''; // this is to reset the field
      descriptionController.text = ''; // this is to reset the field
      showSnackBarMessage("Creation successful");
    } else {
      showSnackBarErrorMessage("Creation Failed");
    }
  }

  void showSnackBarMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blue,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSnackBarErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
