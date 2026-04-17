import 'package:mongo_dart/mongo_dart.dart';
import '../models/task.dart';

class DatabaseService {
  late Db db;
  late DbCollection tasksCollection;

  Future<void> connect() async {
    db = await Db.create('mongodb://localhost:27017/taskflow');
    await db.open();
    tasksCollection = db.collection('tasks');
    print('Connected to MongoDB');
  }

  Future<void> disconnect() async {
    await db.close();
  }

  Future<List<Task>> getAllTasks() async {
    final tasks = await tasksCollection.find().toList();
    return tasks.map((json) => Task.fromJson(json)).toList();
  }

  Future<Task?> getTaskById(String id) async {
    final json = await tasksCollection.findOne(where.id(ObjectId.fromHexString(id)));
    return json != null ? Task.fromJson(json) : null;
  }

  Future<Task> createTask(Task task) async {
    final json = task.toJson();
    json.remove('_id'); // Remove id for insert
    final result = await tasksCollection.insertOne(json);
    task.id = result.id?.toHexString();
    return task;
  }

  Future<Task?> updateTask(String id, Task task) async {
    final json = task.toJson();
    json['_id'] = ObjectId.fromHexString(id);
    final result = await tasksCollection.replaceOne(
      where.id(ObjectId.fromHexString(id)),
      json,
    );
    return result.isSuccess ? task : null;
  }

  Future<bool> deleteTask(String id) async {
    final result = await tasksCollection.deleteOne(where.id(ObjectId.fromHexString(id)));
    return result.isSuccess;
  }
}