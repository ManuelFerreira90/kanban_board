import 'package:flutter/material.dart';
import 'package:kanban_board/components/card_kanban.dart';
import 'package:kanban_board/const.dart';
import 'package:kanban_board/pages/all_notes.dart';
import 'package:kanban_board/pages/all_kanbans.dart';
import '../src/database/db.dart';
import '../src/model/kanban.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  late List<Kanban> _kanbanList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final kanbans = await DB.instance.readAllKanban();
    for (var kanban in kanbans) {
      final tasks = await DB.instance.readTasksFromKanban(kanban.id!);
      kanban.notes = tasks;
    }
    setState(() {
      _kanbanList = kanbans;
    });
  }

  void _editKanbanTitle(BuildContext context, Kanban kanban, VoidCallback restartKanbans) {
    String newTitle = kanban.title;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Kanban Title'),
          content: TextField(
            onChanged: (value) {
              newTitle = value;
            },
            decoration: const InputDecoration(hintText: 'New Title'),

          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (newTitle.isNotEmpty && newTitle != kanban.title) {
                  kanban.title = newTitle;
                  await DB.instance.updateKanban(kanban);
                  restartKanbans();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Kanban title updated!')
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: kColorPurple,
                ),
                child: Text(
                  'Kanban Board',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.sticky_note_2_outlined),
                title: const Text('All notes'),
                onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllNotes(
                            restartKanbans: _loadData,
                            title: 'All Notes',
                            kanbanID: null,
                          )
                      )
                    );
                },
              ),
              ListTile(
                leading: const Icon(Icons.view_kanban_outlined),
                title: const Text('All Kanban Boards'),
                onTap: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllKanbans(
                              restartKanbans: _loadData,
                              editKanbanTitle: _editKanbanTitle,
                            )
                        )
                    );
                  });
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('Kanban Board'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 15.0, right: 20.0),
          child: _kanbanList.isEmpty ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(),
              ),
              const Expanded(
                child: Text(
                  'Create a Kanban Board',
                  style: kSmallText1,
                ),
              ),
            ],
          ) : ListView(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._kanbanList.map((kanban) => CardKanban(
                      kanban: kanban,
                      restartKanbans: _loadData,
                      editKanbanTitle: _editKanbanTitle,
                    )),
                  ],
                ),
              ),
            ],
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
                    decoration:
                        const InputDecoration(hintText: 'Enter Kanban Title'),
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
                          await DB.instance
                              .createKanban(Kanban(title: newKanbanTitle));
                          _loadData();
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
      ),
    );
  }
}
