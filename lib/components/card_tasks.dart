import 'package:flutter/material.dart';
import 'package:kanban_board/pages/tasks_detail_or_create.dart';
import 'content_tasks.dart';
import '../src/model/tasks.dart';
import '../src/database/db.dart';

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

  @override
  void initState() {
    super.initState();
    _currentTasks = widget.tasksList;
    restart = widget.restart;
  }

  VoidCallback? restart;

  void reload() async {
    final tasks = await DB.instance.readTasksFromKanban(widget.kanbanId);
    setState(() {
      _currentTasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(const Size(250.0, 300.0)),
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
                      MaterialPageRoute(builder: (context) => TasksDetailOrCreate(noteID: null,isEditing: false,)),
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
                      // await Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => TasksDetailOrCreate(kanbanId: widget.kanbanId, isEditing: true,)),
                      // );
                      reload();
                    } else if (value == 'delete') {
                      await DB.instance.deleteKanban(widget.kanbanId);
                      restart!();
                    }
                  },
                ),
              ),
              const Divider(),
              SizedBox(
                height: 200.0,
                child: ListView(
                  children: _currentTasks
                      .map((note) => ContentTasks(
                    idTask: note.id!,
                    title: note.title,
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
