import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../pages/tasks_detail_or_create.dart';
import '../src/database/db.dart';

class ContentTasks extends StatelessWidget {
  ContentTasks({
    super.key,
    required this.idTask,
    required this.title,
    required this.idKanban,
    required this.restart,
  });

  final int idKanban;
  final int idTask;
  final String title;
  VoidCallback restart;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey.shade700, width: 0.5),
      ),
      child: ListTile(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                TasksDetailOrCreate(
                  kanbanID: idKanban,
                  noteID: idTask,
                )
            ),
          );
          restart();
        },
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete),
                  SizedBox(width: 8),
                  Text('Excluir'),
                ],
              ),
            ),
          ],
          onSelected: (value) async {
            if (value == 'delete') {
              await DB.instance.deleteTasks(idTask);
              restart();
            }
          },
        ),
        title: Text(title),
      ),
    );
  }
}