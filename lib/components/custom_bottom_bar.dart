import 'package:flutter/material.dart';
import 'package:kanban_board/components/button_save_and_editing.dart';
import 'package:kanban_board/components/selectable_button.dart';
import 'package:kanban_board/src/model/tasks.dart';

class CustomBottomBar extends StatelessWidget {
  bool isEditing;
  final Tasks note;
  final SelectableButton editingButton;
  final VoidCallback saverOrUpdateNote;

  CustomBottomBar({
    super.key,
    required this.isEditing,
    required this.note,
    required this.editingButton,
    required this.saverOrUpdateNote
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, -1), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              editingButton,
              ButtonSaveAndEditing(
                saverOrUpdateNote: saverOrUpdateNote,
                isEditing: isEditing,
                tasks: note,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
