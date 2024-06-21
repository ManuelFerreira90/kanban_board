import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:kanban_board/components/button_save_and_editing.dart';
import 'package:kanban_board/components/custom_bottom_bar.dart';
import 'package:kanban_board/components/selectable_button.dart';
import 'package:kanban_board/components/text_to_markdown.dart';
import 'package:kanban_board/const.dart';
import '../src/model/tasks.dart';
import 'package:intl/intl.dart';
import 'package:markdown_toolbar/markdown_toolbar.dart';
import '../src/database/db.dart';

class DetailOrCreateNote extends StatefulWidget {
  DetailOrCreateNote(
      {super.key,
      required this.note,
      required this.isEditing,
      required this.isModify});

  final Tasks note;
  bool isEditing;
  bool isModify;

  @override
  State<DetailOrCreateNote> createState() => _DetailOrCreateNoteState();
}

class _DetailOrCreateNoteState extends State<DetailOrCreateNote> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Tasks note;
  late bool isEditing;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  double _keyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    note = widget.note;
    isEditing = widget.isEditing;
    _titleController = TextEditingController(text: note.title);
    _contentController = TextEditingController(text: note.content);
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (visible) {
        _scrollToFocusedContent();
      }
    });
    _contentController.addListener(() {
      _scrollToFocusedContent();
    });
    _titleFocusNode.addListener(_onFocusChange);
    _contentFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_titleFocusNode.hasFocus || _contentFocusNode.hasFocus) {
      _scrollToFocusedContent();
    }
  }

  void _scrollToFocusedContent() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_titleFocusNode.hasFocus || _contentFocusNode.hasFocus) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _titleFocusNode.removeListener(_onFocusChange);
    _contentFocusNode.removeListener(_onFocusChange);
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void setIsEditing() {
    setState(() {
      isEditing = true;
    });
  }

  void saverOrUpdateNote() async {
    if (isEditing) {
      await DB.instance.updateTasks(note);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('The note has been updated!')),
      );
    } else {
      final Tasks copyTask = Tasks(
        title: note.title,
        content: note.content,
        kanbanId: note.kanbanId,
        createdTime: DateTime.now(),
      );
      note = await DB.instance.createTasks(copyTask);
      setIsEditing();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('The note has been saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardSizeProvider(
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: const Text('Note'),
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: !widget.isModify
                ? Consumer<ScreenHeight>(
                    builder: (context, screenHeight, child) {
                    _keyboardHeight = screenHeight.keyboardHeight;
                    return SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: _keyboardHeight == 0
                            ? const EdgeInsets.only(bottom: 100)
                            : const EdgeInsets.all(0),
                        child: Column(
                          children: [
                            MarkdownToolbar(
                              backgroundColor: Colors.grey,
                              height: 35,
                              alignment: WrapAlignment.center,
                              hideImage: true,
                              dropdownTextColor: Colors.white,
                              useIncludedTextField: false,
                              controller: _contentController,
                            ),
                            TextFormField(
                              controller: _titleController,
                              focusNode: _titleFocusNode,
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
                              focusNode: _contentFocusNode,
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
                            SizedBox(
                              height: _keyboardHeight,
                            )
                          ],
                        ),
                      ),
                    );
                  })
                : TextToMarkdown(note: note),
          ),
          resizeToAvoidBottomInset: false,
          floatingActionButton: CustomBottomBar(
            saverOrUpdateNote: saverOrUpdateNote,
            isEditing: isEditing,
            note: note,
            editingButton: SelectableButton(
              selected: !widget.isModify,
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.white;
                    }
                    return null; // defer to the defaults
                  },
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.deepPurple;
                    }
                    return null; // defer to the defaults
                  },
                ),
              ),
              onPressed: () {
                setState(() {
                  widget.isModify = !widget.isModify;
                });
              },
              child: const Icon(Icons.edit_note),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}
