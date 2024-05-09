final String tasksTable = 'tasks';

class TasksFields{
  static final String id = '_id';
  static final String title = 'title';
  static final String content = 'content';
  static final String kanbanId = 'kanbanId';
  static final String createdTime = 'createdTime';
}

class Tasks{
  final int id;
  String title;
  String? content;
  int kanbanId;
  final DateTime createdTime;

  Tasks({
    required this.id, 
    required this.title, 
    required this.content, 
    required this.kanbanId,
    required this.createdTime,
  });

  Map<String, Object?> toJson() => {
    TasksFields.id: id,
    TasksFields.title: title,
    TasksFields.content: content,
    TasksFields.kanbanId: kanbanId,
    TasksFields.createdTime: createdTime.toIso8601String(),
  };

  Tasks copy({
    int? id,
    String? title,
    String? content,
    int? kanbanId,
    DateTime? createdTime,
  }) => Tasks(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    kanbanId: kanbanId ?? this.kanbanId,
    createdTime: createdTime ?? this.createdTime,
  );

  static Tasks fromJson(Map<String, Object?> json) => Tasks(
    id: json[TasksFields.id] as int,
    title: json[TasksFields.title] as String,
    content: json[TasksFields.content] as String,
    kanbanId: json[TasksFields.kanbanId] as int,
    createdTime: DateTime.parse(json[TasksFields.createdTime] as String),
  );

}