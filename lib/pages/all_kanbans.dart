import 'package:flutter/material.dart';
import 'package:kanban_board/components/title_card_kanban.dart';
import 'package:kanban_board/src/database/db.dart';
import 'package:kanban_board/src/model/kanban.dart';

import '../const.dart';

class AllKanbans extends StatefulWidget {
  const AllKanbans({
    super.key,
    required this.restartKanbans,
    required this.editKanbanTitle,
  });

  final VoidCallback restartKanbans;
  final Function(BuildContext, Kanban kanban, VoidCallback restartKanbans) editKanbanTitle;

  @override
  State<AllKanbans> createState() => _AllKanbansState();
}

class _AllKanbansState extends State<AllKanbans> {
  List<Kanban> _allKanbans = [];

  @override
  void initState(){
    _loadAllKanbans();
    super.initState();
  }

  void _loadAllKanbans() async{
    final copyAllKanbans = await DB.instance.readAllKanban();
    setState(() {
      _allKanbans = copyAllKanbans;
    });
    widget.restartKanbans();
  }

  void _deleteAllKanbans() async {
    await DB.instance.deleteAllTasks();
    await DB.instance.deleteAllKanban();
    _loadAllKanbans();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('all kanban boards have been deleted!')
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All kanban Boards'),
        actions: [
          _allKanbans.isNotEmpty ? IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Alert'),
                      content: const Text(
                          'Are you sure you want to delete all Kanban Boards?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            _deleteAllKanbans();
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
      body: _allKanbans.isNotEmpty ? Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
        child: Center(
          child: ListView(
            children: [
              ..._allKanbans.map((kanban) => Card(
                child: TitleCardKanban(
                  kanban: kanban,
                  restartKanbans: _loadAllKanbans,
                  editKanbanTitle: widget.editKanbanTitle,
                ),
              )),
            ],
          ),
        ),
      ) : const Center(
        child: Text('no kanbans', style: kSmallText1,),
      )
    );
  }
}
