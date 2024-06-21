import 'package:flutter/material.dart';
import 'package:kanban_board/components/content_note.dart';
import '../const.dart';
import '../src/model/tasks.dart';
import '../src/database/db.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({
    super.key,
    required this.restartKanbans,
    required this.title,
    this.kanbanID,
  });

  final VoidCallback restartKanbans;
  final String title;
  final int? kanbanID;

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  List<Tasks> allNotes = [];

  @override
  void initState() {
    widget.kanbanID == null ? _loadAllNotes() : _loadNotesFromKanban();
    super.initState();
  }

  void _loadAllNotes() async {
    final copyAllNotes = await DB.instance.readAllTasks();
    setState(() {
      allNotes = copyAllNotes;
    });
    widget.restartKanbans();
  }

  void _loadNotesFromKanban() async {
    final copyNotesFromKanban =
        await DB.instance.readTasksFromKanban(widget.kanbanID!);
    setState(() {
      allNotes = copyNotesFromKanban;
    });
  }

  void _deleteAllNotes() async {
    await DB.instance.deleteAllTasks();
    _loadAllNotes();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('all notes have been deleted!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              allNotes.isNotEmpty ? IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Alert'),
                          content: const Text(
                              'Are you sure you want to delete all notes?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                _deleteAllNotes();
                                Navigator.pop(context);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      });
                },
              ) : const SizedBox.shrink()
            ],
          ),
          body: allNotes.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 30.0),
                  child: Center(
                    child: ListView(
                      children: allNotes
                          .map((note) => ContentNote(
                                restart: _loadAllNotes,
                                note: note,
                              ))
                          .toList(),
                    ),
                  ),
                )
              : const Center(
                  child: Text(
                    'no kanbans',
                    style: kSmallText1,
                  ),
                )),
    );
  }
}
