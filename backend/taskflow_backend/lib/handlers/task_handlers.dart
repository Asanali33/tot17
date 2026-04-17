import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../models/task.dart';
import '../services/database_service.dart';

class TaskHandlers {
  final DatabaseService db;

  TaskHandlers(this.db);

  Router get router {
    final router = Router();

    router.get('/tasks', _getAllTasks);
    router.post('/tasks', _createTask);
    router.get('/tasks/<id>', _getTask);
    router.put('/tasks/<id>', _updateTask);
    router.delete('/tasks/<id>', _deleteTask);

    return router;
  }

  Future<Response> _getAllTasks(Request request) async {
    try {
      final tasks = await db.getAllTasks();
      final jsonList = tasks.map((t) => t.toJson()).toList();
      return Response.ok(
        jsonEncode(jsonList),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> _createTask(Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body);
      final task = Task.fromJson(json);
      final createdTask = await db.createTask(task);
      return Response(
        201,
        body: jsonEncode(createdTask.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response(
        400,
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> _getTask(Request request, String id) async {
    try {
      final task = await db.getTaskById(id);
      if (task == null) {
        return Response.notFound(
          jsonEncode({'error': 'Task not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return Response.ok(
        jsonEncode(task.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> _updateTask(Request request, String id) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body);
      final task = Task.fromJson(json);
      final updatedTask = await db.updateTask(id, task);
      if (updatedTask == null) {
        return Response.notFound(
          jsonEncode({'error': 'Task not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return Response.ok(
        jsonEncode(updatedTask.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response(
        400,
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> _deleteTask(Request request, String id) async {
    try {
      final success = await db.deleteTask(id);
      if (!success) {
        return Response.notFound(
          jsonEncode({'error': 'Task not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return Response.ok(
        jsonEncode({'message': 'Task deleted'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}