import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskRepository {
  static const storageKey = 'pocket_tasks_v1';

  // In task_repository.dart, add proper error handling
Future<List<Task>> load() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(storageKey);
    if (jsonString == null || jsonString.isEmpty) return [];
    return Task.decodeList(jsonString);
  } catch (e) {
    return []; // Return empty list on error
  }
}

Future<void> save(List<Task> tasks) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, Task.encodeList(tasks));
  } catch (e) {
    // Could throw or handle gracefully
    rethrow;
  }
}
}
