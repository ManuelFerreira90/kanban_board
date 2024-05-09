import 'tasks.dart';

final String kanbanTable = 'kanban';

class KanbanFields {
  static final String id = '_id';
  static final String title = 'title';
}

class Kanban {
  late int? id;
  late String title;
  late List<Tasks>? notes;

  Kanban({
    this.id,
    required this.title,
  });

  Map<String, Object?> toJson() => {
    KanbanFields.id: id,
    KanbanFields.title: title,
  };

  Kanban copy({
    int? id,
    String? title,
  }) =>
      Kanban(
        id: id ?? this.id,
        title: title ?? this.title,
      );

  static Kanban fromJson(Map<String, Object?> json) => Kanban(
        id: json[KanbanFields.id] as int,
        title: json[KanbanFields.title] as String,
  );
}

