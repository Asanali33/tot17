import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:taskflow_backend/handlers/task_handlers.dart';
import 'package:taskflow_backend/services/database_service.dart';

void main() async {
  final db = DatabaseService();
  await db.connect();

  final taskHandlers = TaskHandlers(db);

  final handler = Pipeline()
      .addMiddleware(corsHeaders())
      .addMiddleware(logRequests())
      .addHandler(taskHandlers.router.call);

  final server = await shelf_io.serve(handler, 'localhost', 8080);
  print('Server running on http://localhost:8080');
}
