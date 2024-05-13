import 'package:flutter/material.dart';
import '../src/database/db.dart';
import '../src/model/tasks.dart';


class ButtonSaveAndEditing extends StatelessWidget {
  const ButtonSaveAndEditing({
    super.key,
    required this.isEditing,
    required this.tasks,
  });

  final Tasks tasks;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (isEditing) {
          await DB.instance.updateTasks(tasks);
        } else {
          final Tasks copyTask = Tasks(
            title: tasks.title,
            content: tasks.content,
            kanbanId: tasks.kanbanId,
            createdTime: DateTime.now(),
          );
          await DB.instance.createTasks(copyTask);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('The note has been saved!')
          ),
        );
      },
      icon: const Icon(Icons.save),
    );
  }
}