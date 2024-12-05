import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/models/todo_model.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch tasks as soon as the screen loads
    Provider.of<TodoProvider>(context, listen: false).fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: todoProvider.tasks.isEmpty
                ? Center(
                    child:
                        CircularProgressIndicator()) // Show loading indicator if tasks are not yet loaded
                : ListView.builder(
                    itemCount: todoProvider.tasks.length,
                    itemBuilder: (context, index) {
                      final task = todoProvider.tasks[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Checkbox(
                            value: task.completed,
                            onChanged: (value) async {
                              // Check if value is different before making an update
                              if (task.completed != value) {
                                await todoProvider.updateTask(
                                  Todo(
                                    id: task.id,
                                    title: task.title,
                                    completed: value!,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Task updated!')),
                                );
                              }
                            },
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.completed
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await todoProvider.deleteTask(task.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Task deleted!')),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      labelText: 'New Task',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(Icons.add),
                  label: Text('Add'),
                  onPressed: () async {
                    if (taskController.text.isNotEmpty) {
                      await todoProvider.addTask(taskController.text);
                      taskController.clear();
                      FocusScope.of(context).unfocus(); // Hide keyboard
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Task added!')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
