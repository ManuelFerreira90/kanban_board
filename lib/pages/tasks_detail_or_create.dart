import 'package:flutter/material.dart';
import '../src/database/db.dart';
import '../src/model/tasks.dart';

class TasksDetailOrCreate extends StatefulWidget {
  const TasksDetailOrCreate({
    Key? key,
    this.title,
    this.content,
    this.noteID,
    required this.isEditing,
  }) : super(key: key);

  final String? title;
  final String? content;
  final int? noteID;
  final bool isEditing;

  @override
  State<TasksDetailOrCreate> createState() => _TasksDetailOrCreateState();
}

class _TasksDetailOrCreateState extends State<TasksDetailOrCreate> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Tasks note;
  int? noteID;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
    noteID = widget.noteID;
    isEditing = widget.isEditing;
    if (noteID != null) {
      loadNote();
    } else {
      note = Tasks(id: null, title: '', content: '', createdTime: DateTime.now());
    }
  }

  void loadNote() async {
    final tasks = await DB.instance.readTasks(noteID!);
    setState(() {
      note = tasks!;
      _titleController.text = note.title;
      _contentController.text = note.content ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Note(
          titleController: _titleController,
          contentController: _contentController,
          isEditing: isEditing,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isEditing) {
            // Update existing note
            await DB.instance.updateTasks(note);
          } else {
            // Create new note
            await DB.instance.createTasks(note);
          }
          Navigator.pop(context);
        },
        child: Icon(isEditing ? Icons.save : Icons.edit),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}

class Note extends StatelessWidget {
  const Note({
    Key? key,
    required this.titleController,
    required this.contentController,
    required this.isEditing,
  }) : super(key: key);

  final TextEditingController titleController;
  final TextEditingController contentController;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Title',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter Title',
          ),
          enabled: !isEditing, // Enable editing based on isEditing state.
        ),
        const SizedBox(height: 16),
        Text(
          'Content',
          style: TextStyle(fontSize: 20),
        ),
        TextFormField(
          controller: contentController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter Content',
          ),
          maxLines: null,
          enabled: !isEditing, // Enable editing based on isEditing state.
        ),
      ],
    );
  }
}

