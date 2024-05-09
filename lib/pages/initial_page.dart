import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../components/card_tasks.dart';
import '../src/database/db.dart';
import '../src/repository/kanban_repository.dart';
import '../src/model/kanban.dart';
import '../src/model/tasks.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final DB _db = DB.instance;

  late List<Kanban> _kanbanList = [];
  late List<Tasks> _tasksList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final kanbans = await DB.instance.readAllKanban();
    for (var kanban in kanbans) {
      final tasks = await DB.instance.readTasksFromKanban(kanban.id!);
      kanban.notes = tasks;
    }
    setState(() {
      _kanbanList = kanbans;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text('Kanban Board'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: (_kanbanList.length * 300),
          child: ListView(
            children: _kanbanList
                .map((kanban) => CardTasks(
                      kanbanId: kanban.id!,
                      title: kanban.title,
                      tasksList: kanban.notes ?? [],
                      restart: loadData,
                    ))
                .toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String newKanbanTitle = '';

              return AlertDialog(
                title: Text('Create New Kanban'),
                content: TextFormField(
                  onChanged: (value) {
                    newKanbanTitle = value;
                  },
                  decoration: InputDecoration(hintText: 'Enter Kanban Title'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (newKanbanTitle.isNotEmpty) {
                        await DB.instance.createKanban(Kanban(title: newKanbanTitle));
                        loadData();
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Create'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
