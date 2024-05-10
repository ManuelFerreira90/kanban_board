import 'package:flutter/material.dart';
import 'package:kanban_board/pages/tasks_detail_or_create.dart';
import 'content_tasks.dart';
import '../src/model/tasks.dart';
import '../src/database/db.dart';
import '../src/model/kanban.dart';

class CardTasks extends StatefulWidget {
  CardTasks({
    Key? key,
    required this.kanbanId,
    required this.title,
    required this.tasksList,
    required this.restart,
  }) : super(key: key);

  final List<Tasks> tasksList;
  final int kanbanId;
  final String title;
  final VoidCallback restart;

  @override
  _CardTasksState createState() => _CardTasksState();
}

class _CardTasksState extends State<CardTasks> {
  late List<Tasks> _currentTasks;
  late int kanbanId;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _currentTasks = widget.tasksList;
    kanbanId = widget.kanbanId;
    _titleController = TextEditingController(text: widget.title);
  }

  void reload() async {
    final tasks = await DB.instance.readTasksFromKanban(widget.kanbanId);
    setState(() {
      _currentTasks = tasks;
    });
  }

  void _editKanbanTitle() {
    _titleController.text = widget.title;
    print(widget.title);
    print(widget.kanbanId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Título do Kanban'),
          content: TextField(
            controller: _titleController,
            decoration: InputDecoration(hintText: 'Novo Título'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final newTitle = _titleController.text.trim();
                Kanban copyKanban = Kanban(
                  title: newTitle,
                  id: widget.kanbanId,
                );
                if (newTitle.isNotEmpty) {
                  await DB.instance.updateKanban(copyKanban);
                  widget.restart();
                  reload();
                  Navigator.pop(context);
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 310.0,
        maxHeight: 350,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(widget.title),
                leading: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TasksDetailOrCreate(
                          noteID: null,
                          kanbanID: kanbanId,
                        ),
                      ),
                    );
                    reload();
                  },
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
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
                    if (value == 'edit') {
                      _editKanbanTitle();
                    } else if (value == 'delete') {
                      await DB.instance.deleteKanban(widget.kanbanId);
                      widget.restart();
                    }
                  },
                ),
              ),
              const Divider(),
              SizedBox(
                height: 250.0,
                child: ListView(
                  children: _currentTasks
                      .map((note) => ContentTasks(
                    restart: reload,
                    title: note.title,
                    idKanban: kanbanId,
                    idTask: note.id!,
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
