import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/database_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks(int userId) async {
    _tasks = await DatabaseService.instance.getTasksByUserId(userId);
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final id = await DatabaseService.instance.insertTask(task);
    _tasks.add(task.copyWith(id: id)); // Add the task with the assigned ID
    notifyListeners();
  }

  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      // Update the task in the database
      await DatabaseService.instance.updateTask(updatedTask);

      // Update the task in the local list
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  Future<void> deleteTask(int taskId) async {
    await DatabaseService.instance.deleteTask(taskId);
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }
}