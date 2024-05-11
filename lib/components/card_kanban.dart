import 'package:flutter/material.dart';
import 'package:kanban_board/components/content_Note.dart';
import 'package:kanban_board/pages/detail_or_create_note.dart';
import 'package:kanban_board/src/database/db.dart';
import 'package:kanban_board/src/model/kanban.dart';
import 'package:kanban_board/src/model/tasks.dart';

class CardKanban extends StatelessWidget {
  const CardKanban({
    super.key,
    required this.kanban,
    required this.restartKanbans,
  });

  final Kanban kanban;
  final VoidCallback restartKanbans;

  void _editKanbanTitle(BuildContext context) {
    String newTitle = kanban.title;
    print(kanban.id);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Título do Kanban'),
          content: TextField(
            onChanged: (value) {
              newTitle = value;
            },
            decoration: const InputDecoration(hintText: 'Novo Título'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (newTitle.isNotEmpty && newTitle != kanban.title) {
                  kanban.title = newTitle;
                  await DB.instance.updateKanban(kanban);
                  restartKanbans();
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 310.0,
        maxHeight: 350,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(kanban.title),
                leading: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailOrCreateNote(
                          note: Tasks(title: '', content: '', kanbanId: kanban.id),
                          isEditing: false,
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
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
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
                  ],
                  onSelected: (value) async {
                    if (value == 'edit') {
                      _editKanbanTitle(context);
                    } else if (value == 'delete') {
                      await DB.instance.deleteKanban(kanban.id!);
                      restartKanbans();
                    }
                  },
                ),
              ),
              const Divider(),
              SizedBox(
                height: 250.0,
                child: ListView(
                  children: kanban.notes!
                      .map((note) => ContentNote(
                    restart: restartKanbans,
                    note: note,
                  ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
