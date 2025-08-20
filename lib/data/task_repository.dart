import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskRepository {
  static const storageKey = 'pocket_tasks_v1';

  Future<List<Task>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(storageKey);
    if (jsonString == null || jsonString.isEmpty) return [];
    return Task.decodeList(jsonString);
    // ensure order by createdAt ascending for stability
  }

  Future<void> save(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TaskRepository.storageKey, Task.encodeList(tasks));
  }
}
