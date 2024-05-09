import 'package:flutter/material.dart';

class TasksDetailOrCreate extends StatefulWidget {
  const TasksDetailOrCreate({
    Key? key,
    this.title,
    this.content,
  }) : super(key: key);

  final String? title;
  final String? content;

  @override
  State<TasksDetailOrCreate> createState() => _TasksDetailOrCreateState();
}

class _TasksDetailOrCreateState extends State<TasksDetailOrCreate> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title ?? '';
    _contentController.text = widget.content ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )
            ),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: null,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_contentController.text),
              ),
            ),
          ],
        ),
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
