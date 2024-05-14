import 'package:flutter/material.dart';
import 'package:kanban_board/pages/all_notes.dart';
import '../src/model/kanban.dart';
import '../src/model/tasks.dart';
import '../const.dart';
import '../pages/detail_or_create_note.dart';
import '../src/database/db.dart';

class TitleCardKanban extends StatelessWidget {
  const TitleCardKanban({
    super.key,
    required this.kanban,
    required this.restartKanbans,
    required this.editKanbanTitle,
  });

  final Kanban kanban;
  final VoidCallback restartKanbans;
  final Function(BuildContext, Kanban kanban, VoidCallback restartKanbans) editKanbanTitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllNotes(restartKanbans: restartKanbans, title: kanban.title)
          ),
        );
      },
      title: Text(kanban.title, style: kTitleKanban),
      leading: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailOrCreateNote(
                note: Tasks(
                    title: '', content: '', kanbanId: kanban.id),
                isEditing: false,
                isModify: false,
              ),
            ),
          );
          restartKanbans();
        },
      ),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit),
                kSizedBoxSpace,
                Text('Edit'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete),
                kSizedBoxSpace,
                Text('Delete'),
              ],
            ),
          ),
        ],
        onSelected: (value) async {
          if (value == 'edit') {
            await editKanbanTitle(context, kanban, restartKanbans);
          } else if (value == 'delete') {
            await DB.instance.deleteTasksFromKanban(kanban.id!);
            await DB.instance.deleteKanban(kanban.id!);
            restartKanbans();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('The kanban board has been successfully deleted!')
              ),
            );
          }
        },
      ),
    );
  }
}