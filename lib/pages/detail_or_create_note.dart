import 'package:flutter/material.dart';
import '../src/database/db.dart';
import '../src/model/tasks.dart';
import 'package:intl/intl.dart';

class DetailOrCreateNote extends StatefulWidget {
  const DetailOrCreateNote({
    super.key,
    required this.note,
    required this.isEditing,
  });

  final Tasks note;
  final bool isEditing;

  @override
  State<DetailOrCreateNote> createState() => _DetailOrCreateNoteState();
}

class _DetailOrCreateNoteState extends State<DetailOrCreateNote> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Tasks note;
  late bool isEditing;

  @override
  void initState() {
    super.initState();
    note = widget.note;
    isEditing = widget.isEditing;
    _titleController = TextEditingController(text: note.title);
    _contentController = TextEditingController(text: note.content);
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
            const Text(
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
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Title',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              note.createdTime != null
                  ? 'Created at: ${DateFormat('dd/MM/yyyy HH:mm').format(note.createdTime!)}'
                  : '',
              style: const TextStyle(
                fontSize: 8,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Content',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _contentController,
              onChanged: (value) {
                setState(() {
                  note.content = value;
                });
              },
              decoration: const InputDecoration(
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
      ),
    );
  }
}


class ButtonSaveAndEditing extends StatelessWidget {
  const ButtonSaveAndEditing({
    super.key,
    required this.isEditing,
    required this.tasks,
  });

  final Tasks tasks;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        if (isEditing) {
          // final Tasks copyTask = Tasks(
          //   id: tasks.id,
          //   title: tasks.title,
          //   content: tasks.content,
          //   kanbanId: tasks.kanbanId,
          //   createdTime: DateTime.now(),
          // );
          await DB.instance.updateTasks(tasks);
        } else {
          final Tasks copyTask = Tasks(
            title: tasks.title,
            content: tasks.content,
            kanbanId: tasks.kanbanId,
            createdTime: DateTime.now(),
          );
          await DB.instance.createTasks(copyTask);
        }
        Navigator.pop(context);
      },
      child: const Icon(Icons.save),
    );
  }
}

