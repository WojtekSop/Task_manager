import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;

  const TaskTile({Key? key, required this.task, required this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(int.parse(task.color)),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: task.fontSize,
            fontFamily: task.font,
          ),
        ),
        subtitle: Text(task.content),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
        ),
      ),
    );
  }
}
