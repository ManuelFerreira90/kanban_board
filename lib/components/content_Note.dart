import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kanban_board/pages/detail_or_create_note.dart';
import 'package:kanban_board/src/model/kanban.dart';
import 'package:kanban_board/src/model/tasks.dart';
import '../src/database/db.dart';

class ContentNote extends StatelessWidget {
  const ContentNote({
    super.key,
    required this.note,
    required this.restart,
  });

  final Tasks note;
  final VoidCallback restart;

  void _moveNote(BuildContext context) async{
    final List<Kanban> kanbans = await DB.instance.readAllKanban();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Move Note To'),
          content: DropdownButtonFormField<Kanban>(
            value: kanbans.first,
            onChanged: (Kanban? newValue) async {
              if (newValue != null) {

                final Tasks copyNote = Tasks(
                  title: note.title,
                  content: note.content,
                  kanbanId: newValue.id,
                  createdTime: note.createdTime,
                );

                await DB.instance.createTasks(copyNote);
                await DB.instance.deleteTasks(note.id!);

                restart();
                Navigator.pop(context);
              }
            },
            items: kanbans.map<DropdownMenuItem<Kanban>>((Kanban kanban) {
              return DropdownMenuItem<Kanban>(
                value: kanban,
                child: Text(kanban.title),
              );
            }).toList(),
          ),
        );
      },
    );
  }

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
                DetailOrCreateNote(
                  note: note,
                  isEditing: true,
                )
            ),
          );
          restart();
        },
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete),
                  SizedBox(width: 8),
                  Text('Excluir'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'move',
              child: Row(
                children: [
                  Icon(Icons.drive_file_move),
                  SizedBox(width: 8),
                  Text('Move to'),
                ],
              ),
            ),
          ],
          onSelected: (value) async {
            if (value == 'delete') {
              await DB.instance.deleteTasks(note.id!);
              restart();
            }
            else if(value == 'move'){
              _moveNote(context);
            }
          },
        ),
        title: Text(note.title),
      ),
    );
  }
}