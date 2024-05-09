import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kanban_board/pages/tasks_detail_or_create.dart';
import 'content_tasks.dart';

class CardTasks extends StatelessWidget {
  CardTasks({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(const Size(250.0, 300.0)),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => (TasksDetailOrCreate())));
                  },
                ),
                title: Text(title),
              ),
              const Divider(),
              SizedBox(
                height: 200.0,
                child: ListView(
                  children: [
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


