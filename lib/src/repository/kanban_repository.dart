import 'package:kanban_board/src/database/db.dart';
import 'package:kanban_board/src/model/kanban.dart';
import 'package:kanban_board/src/model/tasks.dart';

class KanbanRepository {
  final DB _db;

  KanbanRepository(this._db);

  Future<List<Kanban>> getKanbanList() async {
    return await _db.readAllKanban();
  }

  Future<void> addKanban(Kanban kanban) async {
    await _db.createKanban(kanban);
  }

  Future<void> deleteKanban(int id) async {
    await _db.deleteKanban(id);
  }

  Future<List<Tasks>> getTaskList(int kanbanId) async {
    return await _db.readTasksFromKanban(kanbanId);
  }

  Future<void> addTask(Tasks task) async {
    await _db.createTasks(task);
  }

  Future<void> deleteTask(int id) async {
    await _db.deleteTasks(id);
  }
}
