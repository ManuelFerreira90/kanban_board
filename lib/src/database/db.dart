import 'dart:async';

import 'package:kanban_board/src/model/kanban.dart';
import 'package:kanban_board/src/model/tasks.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  DB._();

  static final DB instance = DB._();

  static Database? _database;

  DB._initDB();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('kanban_board.db');
    return _database!;
  } 

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path, version: 1, 
      onCreate: _createDB
    );
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    await db.execute('''
      CREATE TABLE $kanbanTable(
        ${KanbanFields.id} $idType,
        ${KanbanFields.title} TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tasksTable(
        ${TasksFields.id} $idType,
        ${TasksFields.title} TEXT NOT NULL,
        ${TasksFields.content} TEXT,
        ${TasksFields.createdTime} TEXT NOT NULL,
        ${TasksFields.kanbanId} INT,
        FOREIGN KEY(${TasksFields.kanbanId}) REFERENCES $kanbanTable(${KanbanFields.id})
      )
    ''');
  }

  Future<Kanban> createKanban(Kanban kanban) async {
    final db = await instance.database;
    final id = await db.insert(kanbanTable, kanban.toJson());
    return kanban.copy(id: id);
  }

  Future<List<Kanban>> readAllKanban() async {
    final db = await instance.database;
    final orderBy = '${KanbanFields.id} ASC';
    final result = await db.query(kanbanTable, orderBy: orderBy);
    return result.map((json) => Kanban.fromJson(json)).toList();
  }

  Future<Kanban?> readKanban(int id) async {
    final db = await instance.database;
    final result = await db.query(
      kanbanTable,
      where: '${KanbanFields.id} = ?',
      whereArgs: [id],
    );

    if(result.isNotEmpty) {
      return Kanban.fromJson(result.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> updateKanban(Kanban kanban) async {
    final db = await instance.database;
    return db.update(
      kanbanTable,
      kanban.toJson(),
      where: '${KanbanFields.id} = ?',
      whereArgs: [kanban.id],
    );
  }

  Future<int> deleteKanban(int id) async {
    final db = await instance.database;
    return db.delete(
      kanbanTable,
      where: '${KanbanFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllKanban() async {
    final db = await instance.database;
    return db.delete(
      kanbanTable,
    );
  }

  Future<Tasks> createTasks(Tasks tasks) async {
    final db = await instance.database;
    final id = await db.insert(tasksTable, tasks.toJson());
    return tasks.copy(id: id);
  }

  Future<List<Tasks>> readAllTasks() async {
    final db = await instance.database;
    final orderBy = '${TasksFields.id} ASC';
    final result = await db.query(tasksTable, orderBy: orderBy);
    return result.map((json) => Tasks.fromJson(json)).toList();
  }

  Future<List<Tasks>> readTasksFromKanban(int kanbanId) async {
    final db = await instance.database;
    final orderBy = '${TasksFields.id} ASC';
    final result = await db.query(
      tasksTable,
      where: '${TasksFields.kanbanId} = ?',
      whereArgs: [kanbanId],
      orderBy: orderBy,
    );
    return result.map((json) => Tasks.fromJson(json)).toList();
  }

  Future<Tasks?> readTasks(int id) async {
    final db = await instance.database;
    final result = await db.query(
      tasksTable,
      where: '${TasksFields.id} = ?',
      whereArgs: [id],
    );

    if(result.isNotEmpty) {
      return Tasks.fromJson(result.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> updateTasks(Tasks tasks) async {
    final db = await instance.database;
    return db.update(
      tasksTable,
      tasks.toJson(),
      where: '${TasksFields.id} = ?',
      whereArgs: [tasks.id],
    );
  }

  Future<int> deleteTasks(int id) async {
    final db = await instance.database;
    return db.delete(
      tasksTable,
      where: '${TasksFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTasksFromKanban(int id) async {
    final db = await instance.database;
    return db.delete(
      tasksTable,
      where: '${TasksFields.kanbanId} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllTasks() async {
    final db = await instance.database;
    return db.delete(
      tasksTable,
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}