import 'package:flutter/material.dart';
import '../src/database/db.dart';
import '../src/model/tasks.dart';

class TasksDetailOrCreate extends StatefulWidget {
  const TasksDetailOrCreate({
    Key? key,
    this.noteID,
    required this.kanbanID,
  }) : super(key: key);

  final int kanbanID;
  final int? noteID;

  @override
  State<TasksDetailOrCreate> createState() => _TasksDetailOrCreateState();
}

class _TasksDetailOrCreateState extends State<TasksDetailOrCreate> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Tasks note;
  late bool isEditing;
  late int kanbanID;
  late int? noteID;

  @override
  void initState() {
    super.initState();
    noteID = widget.noteID ?? null;
    isEditing = noteID != null;
    kanbanID = widget.kanbanID;
    note = Tasks(id: 0, title: '', content: '', kanbanId: kanbanID); // Initialize note with default values
    if(isEditing){
      _loadTask();
    }
    else{
      _titleController = TextEditingController(text: note.title);
      _contentController = TextEditingController(text: note.content);
    }
    print(note.title);
  }

  void _loadTask() async {
    final tasks = await DB.instance.readTasks(noteID!);
    setState(() {
      this.note = tasks!;
      _titleController = TextEditingController(text: note.title);
      _contentController = TextEditingController(text: note.content);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _titleController,
              onChanged: (value) {
                setState(() {
                  note.title = value;
                });
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Title',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Content',
              style: TextStyle(fontSize: 20),
            ),
            TextFormField(
              controller: _contentController,
              onChanged: (value) {
                setState(() {
                  note.content = value;
                });
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Content',
              ),
              maxLines: null,
            ),
          ],
        ),
      ),
      floatingActionButton: ButtonSaveAndEditing(
        isEditing: isEditing,
        tasks: note,
        kanbanID: kanbanID,
      ),
    );
  }
}


class ButtonSaveAndEditing extends StatelessWidget {
  const ButtonSaveAndEditing({
    Key? key,
    required this.isEditing,
    required this.tasks,
    required this.kanbanID,
  }) : super(key: key);

  final int kanbanID;
  final Tasks tasks;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        if (isEditing) {
          final Tasks copyTask = Tasks(
            id: tasks.id,
            title: tasks.title,
            content: tasks.content,
            kanbanId: kanbanID,
            createdTime: DateTime.now(),
          );
          await DB.instance.updateTasks(copyTask);
        } else {
          final Tasks copyTask = Tasks(
            title: tasks.title,
            content: tasks.content,
            kanbanId: kanbanID,
            createdTime: DateTime.now(),
          );
          await DB.instance.createTasks(copyTask);
        }
        Navigator.pop(context);
      },
      child: Icon(Icons.save),
    );
  }
}

