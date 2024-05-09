import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ContentTasks extends StatelessWidget {
  const ContentTasks({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        //subtitle: Text('Description 1'),
      ),
    );
  }
}