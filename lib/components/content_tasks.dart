import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../pages/tasks_detail_or_create.dart';

class ContentTasks extends StatelessWidget {
  const ContentTasks({
    super.key,
    required this.idTask,
    required this.title,
  });

  final int idTask;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                TasksDetailOrCreate(noteID: null, isEditing: true,)),
          );
        },
        title: Text(title),
        //subtitle: Text('Description 1'),
      ),
    );
  }
}