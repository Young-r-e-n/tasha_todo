import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  static const String baseUrl = 'http://localhost/todobackend/todos/todos.php';
  List<Todo> _tasks = [];

  List<Todo> get tasks => _tasks;

  // Fetch all tasks
Future<void> fetchTasks() async {
  try {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        _tasks = (data['todos'] as List)
            .map<Todo>((task) => Todo.fromJson(task))
            .toList();
        notifyListeners(); // Notify listeners after data is fetched
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Failed to fetch tasks');
    }
  } catch (e) {
    debugPrint('Error fetching tasks: ${e.toString()}');
    throw Exception('Error fetching tasks: ${e.toString()}');
  }
}

  // Add a new task
  Future<void> addTask(String title) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {'title': title, 'completed': '0'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!data['success']) {
          throw Exception(data['message']);
        }
        await fetchTasks(); // Refresh task list
      } else {
        throw Exception('Failed to add task');
      }
    } catch (e) {
      throw Exception('Error adding task: ${e.toString()}');
    }
  }

  // Update an existing task
// Update an existing task
  Future<void> updateTask(Todo task) async {
    try {
      final response = await http.put(
        Uri.parse(baseUrl),
        body: {
          'id': task.id.toString(),
          'title': task.title,
          'completed': task.completed ? '1' : '0', // Ensure correct value is sent
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!data['success']) {
          throw Exception(data['message']);
        }

        // Update the task locally
        final index = _tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          _tasks[index] = task; // Update the task in the local list
          notifyListeners(); // Notify listeners to update the UI
        }
      } else {
        throw Exception('Failed to update task');
      }
    } catch (e) {
      throw Exception('Error updating task: ${e.toString()}');
    }
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(baseUrl),
        body: {'id': id.toString()},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!data['success']) {
          throw Exception(data['message']);
        }
        await fetchTasks(); // Refresh task list
      } else {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      throw Exception('Error deleting task: ${e.toString()}');
    }
  }
}
