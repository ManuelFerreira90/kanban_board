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
  final KanbanRepository _kanbanRepository = KanbanRepository(DB.instance);

  List<Kanban> _kanbanList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final kanbans = await _kanbanRepository.getKanbanList();
    print('Kanban List: $kanbans');
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
                      key: ValueKey(kanban.id),
                      title: kanban.title,
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
                        await _kanbanRepository.addKanban(Kanban(title: newKanbanTitle));
                        _loadData();
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
