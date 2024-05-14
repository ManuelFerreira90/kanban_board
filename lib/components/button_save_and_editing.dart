import 'package:flutter/material.dart';
import '../src/database/db.dart';
import '../src/model/tasks.dart';


class ButtonSaveAndEditing extends StatelessWidget {
  ButtonSaveAndEditing({
    super.key,
    required this.isEditing,
    required this.tasks,
    required this.saverOrUpdateNote,
  });

  final VoidCallback saverOrUpdateNote;
  final Tasks tasks;
  bool isEditing;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: saverOrUpdateNote,
      icon: const Icon(Icons.save),
    );
  }
}