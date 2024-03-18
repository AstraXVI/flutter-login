import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ToDo List'),
        primary: true,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[300],
      ),
      body: ListView(
        children: const [
          Todos(""),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddTodoDialog(); // Call the separate widget for dialog content
            },
          );
        },
        backgroundColor: Colors.blueAccent[150],
        hoverColor: Colors.blue[50],
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _todo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.lightBlue[50],
      title: const Text('Add Todo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _todo,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
              },
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // _formKey.currentState?.validate() ?? false
              String todo = _todo.text;
              const url = 'http://192.168.1.136:8012/flutterBE/addTodo.php';

              final response = await http.post(
                Uri.parse(url),
                body: {
                  'todo': todo,
                },
              );

              // Log response
              // debugPrint('Response: ${response.body}');

              if (response.statusCode == 200) {
                final responseData = jsonDecode(response.body);
                if (responseData['status'] == 'error') {
                  // Handle error
                  // Show message to the user
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(responseData['message']),
                  ));
                } else {
                  IconSnackBar.show(context,
                      snackBarStyle: const SnackBarStyle(
                        maxLines: 1,
                      ),
                      snackBarType: SnackBarType.save,
                      label: 'Added successfully');
                }
              } else {
                // Handle error
                // Show message to the user
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Failed to authenticate'),
                ));
              }

              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}



class Todos extends StatelessWidget {
  final String todo;

  const Todos(this.todo, {super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      child: ListTile(
        title: Text(todo),
        tileColor: Colors.blueGrey[100],
      ),
    );
  }

//   Future<void> fetchTodos() async {
//     final response = await http.get(Uri.parse('http://example.com/get_todos.php'));

//     if (response.statusCode == 200) {
//       // Parse response data
//       final List<dynamic> data = jsonDecode(response.body);

//       // Update todos list
//       setState(() {
//         todos = data.map((item) => item['todo'] as String).toList();
//       });
//     } else {
//       // Handle error
//       // Show error message to the user
//     }
//   }
}