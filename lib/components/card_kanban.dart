import 'package:flutter/material.dart';
import 'package:kanban_board/components/content_note.dart';
import 'package:kanban_board/components/title_card_kanban.dart';
import 'package:kanban_board/const.dart';
import 'package:kanban_board/src/model/kanban.dart';

class CardKanban extends StatelessWidget {
  const CardKanban({
    super.key,
    required this.kanban,
    required this.restartKanbans,
    required this.editKanbanTitle,
  });

  final Kanban kanban;
  final VoidCallback restartKanbans;
  final Function(BuildContext, Kanban kanban, VoidCallback restartKanbans) editKanbanTitle;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: kCard,
      child: Card(
        margin: const EdgeInsets.only(bottom: 15, left: 20.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TitleCardKanban(
                  kanban: kanban,
                  restartKanbans: restartKanbans,
                  editKanbanTitle: editKanbanTitle,
              ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Column(
                  children: kanban.notes!
                      .map((note) => ContentNote(
                    restart: restartKanbans,
                    note: note,
                  ))
                      .toList(),
                ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}


