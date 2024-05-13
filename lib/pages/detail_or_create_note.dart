import 'package:flutter/material.dart';
import 'package:kanban_board/const.dart';
import '../src/model/tasks.dart';
import 'package:intl/intl.dart';
import '../components/button_save_and_editing.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class DetailOrCreateNote extends StatefulWidget {
  DetailOrCreateNote({
    super.key,
    required this.note,
    required this.isEditing,
  });

  final Tasks note;
  final bool isEditing;
  bool isModify = false;

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
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: const Text('Note'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
          child: widget.isModify ? ListView(
            children: [
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
              Text(
                note.createdTime != null
                    ? 'Created at: ${DateFormat('dd/MM/yyyy HH:mm').format(note.createdTime!)}'
                    : '',
                style: kSmallText,
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
          ) : ListView(
            children: [
              MarkdownBody(
                  data: '# ${note.title}'
              ),
              Text(
                note.createdTime != null
                    ? 'Created at: ${DateFormat('dd/MM/yyyy HH:mm').format(note.createdTime!)}'
                    : '',
                style: kSmallText,
              ),
              const SizedBox(height: 16),
              MarkdownBody(
                  data: note.content!
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonSaveAndEditing(
                isEditing: isEditing,
                tasks: note,
              ),
              IconButton(
                onPressed: (){
                  setState(() {
                    widget.isModify = !widget.isModify;
                  });
                },
                icon: const Icon(Icons.edit_note),
              ),
            ],
          ),
        ),



        // floatingActionButton: ButtonSaveAndEditing(
        //   isEditing: isEditing,
        //   tasks: note,
        // ),
      ),
    );
  }
}




