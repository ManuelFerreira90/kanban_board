import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kanban_board/components/card_kanban.dart';
import '../src/database/db.dart';
import '../src/model/kanban.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final DB _db = DB.instance;

  late List<Kanban> _kanbanList = [];

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
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF4F378B),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: IconButton(
            icon: const Icon(Icons.edit_note),
            onPressed: () {},
          ),
        ),
        title: const Text('Kanban Board'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: SizedBox(
          height: (_kanbanList.length * 380),
          child: ListView(
            children: [
              Center(
                child: Wrap(
                  children:
                    _kanbanList
                        .map((kanban) => CardKanban(
                      kanban: kanban,
                      restartKanbans: loadData,
                    ))
                        .toList(),
                ),
              ),
            ]
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
                title: const Text('Create New Kanban'),
                content: TextFormField(
                  onChanged: (value) {
                    newKanbanTitle = value;
                  },
                  decoration: const InputDecoration(hintText: 'Enter Kanban Title'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (newKanbanTitle.isNotEmpty) {
                        await DB.instance.createKanban(Kanban(title: newKanbanTitle));
                        loadData();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
